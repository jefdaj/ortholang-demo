#!/usr/bin/env python2

# TODO thank that guy for the random numbers example that fixed the bug
# TODO clean up all these crazy global variables? or is that just python...

import logging as LOGGING

from datetime           import datetime
from flask              import Flask, render_template, request, make_response
from flask_socketio     import SocketIO, emit
from flaskext.markdown  import Markdown
from glob               import glob
from signal             import SIGKILL
from os                 import setsid, getpgid, killpg
from os.path            import join, realpath, dirname
from psutil             import cpu_percent, virtual_memory
from re                 import sub, DOTALL
from shutil             import rmtree
from subprocess         import Popen, PIPE, STDOUT
from threading          import Thread, Event
from time               import sleep
from twisted.internet   import reactor as REACTOR
from twisted.web.server import Site
from twisted.web.wsgi   import WSGIResource
from uuid               import uuid4


###########
# logging #
###########

# see https://www.blog.pythonlibrary.org/2012/08/02/python-101-an-intro-to-logging/
# all modules will use this
HANDLER = LOGGING.FileHandler('shortcut_demo.log')
HANDLER.setFormatter(LOGGING.Formatter('%(asctime)s %(name)s %(levelname)s %(message)s'))

# set up logging for this module
# note: socketio + engineio loggers are messed with later
LOGGER = LOGGING.getLogger('shortcut')
LOGGER.setLevel(LOGGING.INFO)
LOGGER.addHandler(HANDLER)
LOGGER.info('starting shortcut_demo.py')

def timestamp():
    return datetime.today().strftime('%Y-%m-%d_%H:%M:%S')


###############
# server load #
###############

class ServerLoadThread(Thread):
    def __init__(self):
        self.delay = 5
        self.n_sessions= 0
        super(ServerLoadThread, self).__init__()
        self.daemon = True

    def run(self):
        LOGGER.info('starting ServerLoadThread')
        while True:
            self.emitInfo()
            sleep(self.delay)

    def emitInfo(self):
        cpu = round(cpu_percent())
        mem = round(virtual_memory().percent)
        nfo = {'users': self.n_sessions, 'cpu': cpu, 'memory': mem}
        LOGGER.info('emitting serverload: %s' % nfo)
        SOCKETIO.emit('serverload', nfo, namespace='/')

    def sessionStarted(self):
        self.n_sessions += 1

    def sessionEnded(self):
        self.n_sessions -= 1

# this is started later because it needs SOCKETIO
LOAD = ServerLoadThread()


#########
# flask #
#########

# TODO any way (or reason) to not run this when importing the module?
FLASK = Flask(__name__)
FLASK.config['SECRET_KEY'] = 'so-secret!'
MARKDOWN = Markdown(FLASK) # TODO should this be used when rendering templates?

# used to render the code examples
EXAMPLES = {}
for path in glob('data/*.cut'):
    with open(path, 'r') as f:
        txt = f.read()
    EXAMPLES[path] = {'id': path.replace('/', '_'), 'content': txt}

@FLASK.route('/')
def index():
    return render_template('index.html', examples=EXAMPLES)


############
# socketio #
############

SOCKETIO = SocketIO(FLASK, manage_session=False, logger=True, engineio_logger=True)
LOAD.start()

# swap other modules' log handlers for mine
LOGGING.getLogger('socketio').handlers = []
LOGGING.getLogger('socketio').addHandler(HANDLER)
LOGGING.getLogger('engineio').handlers = []
LOGGING.getLogger('engineio').addHandler(HANDLER)

@SOCKETIO.on('connect')
def handle_connect():
    sid = request.sid
    LOGGER.info('client %s connected' % sid)
    global SESSIONS
    if not sid in SESSIONS:
        SESSIONS[sid] = ShortcutThread(sid)
    thread = SESSIONS[sid]
    if not thread.isAlive():
        thread.start()

@SOCKETIO.on('disconnect')
def handle_disconnect():
    LOGGER.info('client %s disconnected' % request.sid)
    global LOAD
    LOAD.sessionEnded()
    thread = SESSIONS[request.sid]
    thread._done.set()
    thread.killRepl()

@SOCKETIO.on('replstdin')
def handle_replstdin(line):
    SESSIONS[request.sid].readLine(line)

@SOCKETIO.on('comment')
def handle_comment(comment):
    sid = request.sid
    LOGGER.info("client %s submitted a comment: '%s'" % (sid, comment))
    filename = join('comments', '%s_%s.txt' % (timestamp(), sid))
    with open(filename, 'w') as f:
        f.write(comment.encode('utf-8'))


############
# shortcut #
############

class ShortcutThread(Thread):
    def __init__(self, sessionid):
        LOGGER.info('creating session %s' % sessionid)
        self.delay = 0.01
        self.sessionid = sessionid
        self.tmpdir = join(realpath('static/tmpdirs'), sessionid)
        self.datadir = realpath('data')
        self._done = Event()
        self.process = None
        self.spawnRepl()
        super(ShortcutThread, self).__init__()

    def run(self):
        global LOAD
        LOAD.sessionStarted()
        while not self._done.is_set():
            self.spawnRepl()
            self.emitStdout()
        LOAD.sessionEnded()

    def killRepl(self):
        # see https://stackoverflow.com/a/22582602
        LOGGER.info('session %s killing interpreter %s' % (self.sessionid, self.process.pid))
        pgid = getpgid(self.process.pid)
        killpg(pgid, SIGKILL)
        self.process.wait()
        rmtree(self.tmpdir, ignore_errors=True)

    def spawnRepl(self):
        if self.process is not None:
            self.killRepl()
        cmd = ['shortcut', '--secure', '--interactive',
               '--tmpdir', self.tmpdir, '--workdir', self.datadir]
        self.process = Popen(cmd, stdin=PIPE, stdout=PIPE, stderr=STDOUT, preexec_fn=setsid)
        LOGGER.info('session %s spawned interpreter %s' % (self.sessionid, self.process.pid))

    def emitLine(self, line):
        # hack to show images in the repl
        # TODO also hack it to show them one per line
        # TODO ... and with list brackets?
        old = ".*plot image '(.*?)'.*"
        new = r' <img src="\1" style="max-width: 400px;"></img> '
        line = sub(old, new, line, flags=DOTALL)
        line = sub(dirname(self.tmpdir), 'static/tmpdirs', line)
        SOCKETIO.emit('replstdout', line, namespace='/', room=self.sessionid)

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

SESSIONS = {}


###########
# twisted #
###########

# this is based on https://gist.github.com/ianschenck/977379a91154fe264897
# but I had trouble getting the reloader to work without zombie processes

RESOURCE = WSGIResource(REACTOR, REACTOR.getThreadPool(), FLASK)
SITE = Site(RESOURCE)
REACTOR.listenTCP(5000, SITE)
REACTOR.run(installSignalHandlers=True)
