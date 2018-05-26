#!/usr/bin/env python2

# TODO thank that guy for the random numbers example that fixed the bug

import logging

from datetime           import datetime
from flask              import Flask, render_template, request, make_response
from flask_socketio     import SocketIO, emit
from flaskext.markdown  import Markdown
from glob               import glob
from signal             import SIGKILL
from os                 import setsid, getpgid, killpg
from os.path            import join, realpath
from psutil             import cpu_percent, virtual_memory
from re                 import sub, DOTALL
from shutil             import rmtree
from subprocess         import Popen, PIPE, STDOUT
from threading          import Thread, Event
from time               import sleep
from twisted.internet   import reactor
from twisted.web.server import Site
from twisted.web.wsgi   import WSGIResource
from uuid               import uuid4


###########
# logging #
###########

# see https://www.blog.pythonlibrary.org/2012/08/02/python-101-an-intro-to-logging/
# all modules will use this
fh = logging.FileHandler('shortcut_demo.log')
fh.setFormatter(logging.Formatter('%(asctime)s %(name)s %(levelname)s %(message)s'))

# set up logging for this module
# note: socketio + engineio loggers are messed with later
log = logging.getLogger('shortcut')
log.setLevel(logging.INFO)
log.addHandler(fh)
log.info('starting shortcut_demo.py')

def timestamp():
    return datetime.today().strftime('%Y-%m-%d_%H:%M:%S')


####################
# shortcut threads #
####################

class ShortcutThread(Thread):
    def __init__(self, sessionid):
        log.info('creating new ShortcutThread with shortcut-session-id %s' % sessionid)
        self.delay = 0.01
        self.sessionid = sessionid
        self.tmpdir = join(realpath('static/tmpdirs'), sessionid)
        self.datadir = realpath('data')
        self._done = Event()
        self.process = None
        self.spawnRepl()
        super(ShortcutThread, self).__init__()

    def run(self):
        global server_info
        server_info.sessionStarted()
        while not self._done.is_set():
            self.spawnRepl()
            self.emitStdout()
        server_info.sessionEnded()

    def killRepl(self):
        # see https://stackoverflow.com/a/22582602
        log.info('killing session %s' % self.sessionid)
        pgid = getpgid(self.process.pid)
        killpg(pgid, SIGKILL)
        self.process.wait()
        rmtree(self.tmpdir, ignore_errors=True)

    def spawnRepl(self):
        if self.process is not None:
            self.killRepl()
        log.info('spawning repl with shortcut-session-id %s' % self.sessionid)
        cmd = ['shortcut', '--secure', '--interactive', '--tmpdir', self.tmpdir, '--workdir', self.datadir]
        self.process = Popen(cmd, stdin=PIPE, stdout=PIPE, stderr=STDOUT, bufsize=1, preexec_fn=setsid)

    def emitLine(self, line):
        # hacky way to show images in the repl
        old = ".*plot image '(.*?)'.*"
        new = r' <img src="\1" style="max-width: 400px;"></img> '
        line = sub(old, new, line, flags=DOTALL)
        line = sub('/tmp/tmpdirs', 'static/tmpdirs', line)
        socketio.emit('replstdout', line, namespace='/', room=self.sessionid)

    def readLine(self, line):
        try:
            self.process.stdin.write(line + '\n')
            self.emitLine('>> ' + line + '\n')
        except IOError:
            if not self._done.is_set():
                self.emitLine('Resetting demo...\n')
                self.spawnRepl()
                sleep(2)
                self.readLine(line)

    def emitStdout(self):
        while True:
            sleep(self.delay) # TODO remove? decrease?
            try:
                line = self.process.stdout.readline()
            except:
                break
            if line:
                line = sub(r'^(>> )*', '', line)
                self.emitLine(line)

shortcut_threads = {}


#############
# webserver #
#############

# TODO any way (or reason) to not run this when importing the module?
app = Flask(__name__)
Markdown(app)
app.config['SECRET_KEY'] = 'so-secret!'
socketio = SocketIO(app, manage_session=False, logger=True, engineio_logger=True)

# swap other modules' log handlers for mine
logging.getLogger('socketio').handlers = []
logging.getLogger('socketio').addHandler(fh)
logging.getLogger('engineio').handlers = []
logging.getLogger('engineio').addHandler(fh)

class ServerInfoThread(Thread):
    def __init__(self):
        self.delay = 5
        self.n_sessions= 0
        super(ServerInfoThread, self).__init__()
        self.daemon = True

    def run(self):
        log.info('starting ServerInfoThread')
        while True:
            self.emitInfo()
            sleep(self.delay)

    def emitInfo(self):
        cpu = round(cpu_percent())
        mem = round(virtual_memory().percent)
        nfo = {'users': self.n_sessions, 'cpu': cpu, 'memory': mem}
        log.info('emitting serverinfo: %s' % nfo)
        socketio.emit('serverinfo', nfo, namespace='/')

    def sessionStarted(self):
        self.n_sessions += 1

    def sessionEnded(self):
        self.n_sessions -= 1

server_info = ServerInfoThread()
server_info.start()

# used to render the code examples
examples = {}
for path in glob('data/*.cut'):
    with open(path, 'r') as f:
        txt = f.read()
    examples[path] = {'id': path.replace('/', '_'), 'content': txt}

@app.route('/')
def index():
    return render_template('index.html', examples=examples)

@socketio.on('connect')
def handle_connect():
    sid = request.sid
    log.info('client %s connected' % sid)
    global shortcut_threads
    if not sid in shortcut_threads:
        shortcut_threads[sid] = ShortcutThread(sid)
    thread = shortcut_threads[sid]
    if not thread.isAlive():
        thread.start()

@socketio.on('disconnect')
def handle_disconnect():
    log.info('client %s disconnected' % request.sid)
    global server_info
    server_info.sessionEnded()
    thread = shortcut_threads[request.sid]
    thread._done.set()
    thread.killRepl()

@socketio.on('replstdin')
def handle_replstdin(line):
    shortcut_threads[request.sid].readLine(line)

@socketio.on('comment')
def handle_comment(comment):
    sid = request.sid
    log.info("client %s submitted a comment: '%s'" % (sid, comment))
    filename = join('comments', '%s_%s.txt' % (timestamp(), sid))
    with open(filename, 'w') as f:
        f.write(comment.encode('utf-8'))

########
# main #
########

# based on https://gist.github.com/ianschenck/977379a91154fe264897
# but I had trouble getting the reloader to work without zombie processes

resource = WSGIResource(reactor, reactor.getThreadPool(), app)
site = Site(resource)
reactor.listenTCP(5000, site)
reactor.run(installSignalHandlers=True)
