#!/usr/bin/env python2

# TODO thank that guy for the random numbers example that fixed the bug

from datetime          import datetime
from flask             import Flask, render_template, request, make_response
from flask_socketio    import SocketIO, emit
from flaskext.markdown import Markdown
from glob              import glob
from os.path           import join, realpath
from psutil            import cpu_percent, virtual_memory
from re                import sub, DOTALL
from shutil            import rmtree
from subprocess        import Popen, PIPE, STDOUT
from threading         import Thread, Event
from time              import sleep
from uuid              import uuid4

#############
# utilities #
#############

def timestamp():
    return datetime.today().strftime('%Y-%m-%d_%H:%M:%S')

def log(msg):
    print '[%s] %s' % (timestamp(), msg)

####################
# shortcut threads #
####################

class ShortcutThread(Thread):
    def __init__(self, sessionid):
        log('creating new ShortcutThread with shortcut-session-id %s' % sessionid)
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
        log('spawning repl with shortcut-session-id %s' % self.sessionid)
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

app = Flask(__name__)
Markdown(app)
app.config['SECRET_KEY'] = 'so-secret!'
socketio = SocketIO(app, manage_session=False, logger=True, engineio_logger=True)

class ServerInfoThread(Thread):
    def __init__(self):
        self.delay  = 5
        self.users  = 0
        super(ServerInfoThread, self).__init__()
        self.daemon = True

    def run(self):
        log('starting ServerInfoThread')
        while True:
            self.emitInfo()
            sleep(self.delay)

    def emitInfo(self):
        cpu = round(cpu_percent())
        mem = round(virtual_memory().percent)
        nfo = {'users': self.users, 'cpu': cpu, 'memory': mem}
        log('emitting serverinfo: %s' % nfo)
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
    print('client %s connected' % sid)
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
    log('client %s disconnected' % request.sid)
    shortcut_threads[request.sid].kill() # TODO any point to waiting a while first?
    global server_info
    server_info.userDisconnected()

@socketio.on('replstdin')
def handle_replstdin(line):
    shortcut_threads[request.sid].readLine(line)

@socketio.on('comment')
def handle_comment(comment):
    sid = request.sid
    log("client %s submitted a comment: '%s'" % (sid, comment))
    filename = join('comments', '%s_%s.txt' % (timestamp(), sid))
    with open(filename, 'w') as f:
        f.write(comment.encode('utf-8'))

if __name__ == '__main__':
    socketio.run(app, debug=True)
