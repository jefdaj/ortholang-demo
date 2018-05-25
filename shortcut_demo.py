#!/usr/bin/env python2

# TODO thank that guy for the random numbers example that fixed the bug

import logging

from datetime           import datetime
from flask              import Flask, render_template, request, make_response
from flask_socketio     import SocketIO, emit
from flask_twisted      import Twisted
from flaskext.markdown  import Markdown
from glob               import glob
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
log = logging.getLogger('shortcut_demo')
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
        self._stop = Event()
        self.spawnRepl()
        super(ShortcutThread, self).__init__()

    def run(self):
        while True:
            self.emitStdout()
            if self._stop.is_set():
                break
            else:
                self.spawnRepl()
        self.cleanup()

    def kill(self):
        self._stop.set()
        self.process.kill()
        self.cleanup()

    def cleanup(self):
        try:
            self.process.kill()
        except:
            pass
        finally:
            rmtree(self.tmpdir, ignore_errors=True)

    def spawnRepl(self):
        log.info('spawning repl with shortcut-session-id %s' % self.sessionid)
        cmd = ['shortcut', '--interactive', '--tmpdir', self.tmpdir, '--workdir', self.datadir]
        self.process = Popen(cmd, stdin=PIPE, stdout=PIPE, stderr=STDOUT, bufsize=1)

    def emitLine(self, line):
        # hacky way to show images in the repl
        line = sub(".*plot image '(.*?)'.*", r' <img src="\1" style="max-width: 400px;"></img> ', line, flags=DOTALL)
        line = sub('/tmp/tmpdirs', 'static/tmpdirs', line)
        socketio.emit('replstdout', line, namespace='/', room=self.sessionid)

    def readLine(self, line):
        self.emitLine('>> ' + line + '\n')
        try:
            self.process.stdin.write(line + '\n')
        except IOError:
            if not self._stop.is_set():
                self.emitLine('Shortcut died. Resetting demo...\n\n')
                self.spawnRepl()
                self.process.stdin.write(line + '\n')

    def emitStdout(self):
        while True:
            sleep(self.delay)
            try:
                line = self.process.stdout.readline()
            except:
                self.process.terminate() # TODO remove? kill instead?
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
Twisted(app)
Markdown(app)
app.config['SECRET_KEY'] = 'so-secret!'
socketio = SocketIO(app, manage_session=False, logger=True, engineio_logger=True)

# swap other modules' log handlers for mine
logging.getLogger().handlers = []
logging.getLogger().addHandler(fh)
logging.getLogger('socketio').handlers = []
logging.getLogger('socketio').addHandler(fh)
logging.getLogger('engineio').handlers = []
logging.getLogger('engineio').addHandler(fh)

class ServerInfoThread(Thread):
    def __init__(self):
        self.delay  = 5
        self.users  = 0
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
        nfo = {'users': self.users, 'cpu': cpu, 'memory': mem}
        log.info('emitting serverinfo: %s' % nfo)
        socketio.emit('serverinfo', nfo, namespace='/')

    def userConnected(self):
        self.users += 1

    def userDisconnected(self):
        self.users -= 1

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
    global server_info
    server_info.userConnected()

@socketio.on('disconnect')
def handle_disconnect():
    log.info('client %s disconnected' % request.sid)
    shortcut_threads[request.sid].kill() # TODO any point to waiting a while first?
    global server_info
    server_info.userDisconnected()

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

def run_twisted_wsgi(app):
    # based on https://gist.github.com/ianschenck/977379a91154fe264897
    # TODO can this be run interactively or is it a once-only thing?
    reactor_args = {}
    resource = WSGIResource(reactor, reactor.getThreadPool(), app)
    site = Site(resource)
    reactor.listenTCP(5000, site)
    reactor.run(**reactor_args)
    if app.debug:
        # Disable twisted signal handlers in development only.
        reactor_args['installSignalHandlers'] = 0
        # Turn on auto reload.
        import werkzeug.serving
        run_twisted_wsgi = werkzeug.serving.run_with_reloader(run_twisted_wsgi)

if __name__ == "__main__":
    run_twisted_wsgi(app)
