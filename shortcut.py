#!/usr/bin/env python2

# TODO thank that guy for the random numbers example that fixed the bug
# TODO broadcast to clients individually rather than everyone at once
# TODO repl should respawn when it crashes or is exited

from datetime       import datetime
from flask          import Flask, render_template, request, make_response
from flask_login    import LoginManager
from flask_session  import Session
from flask_socketio import SocketIO, emit
from os.path        import join, realpath
from re             import sub
from subprocess     import Popen, PIPE, STDOUT
from threading      import Thread
from time           import sleep
from uuid           import uuid4

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

# TODO is this good enough, or is an actual lock still needed?
shortcut_threads = {}

class ShortcutThread(Thread):
    def __init__(self, sessionid):
        log('creating new ShortcutThread with shortcut-session-id %s' % sessionid)
        self.delay = 0.01
        self.sessionid = sessionid
        self.tmpdir = join(realpath('tmpdirs'), sessionid)

        # TODO better bufsize?
        # TODO put stderr somewhere besides main output?
        # TODO separate launchProcess method?
        cmd = ['shortcut', '--interactive', '--tmpdir', self.tmpdir]
        self.process = Popen(cmd, stdin=PIPE, stdout=PIPE, stderr=STDOUT, bufsize=1)
        super(ShortcutThread, self).__init__()

    def run(self):
        # TODO handle restarting the process when killed here?
        self.emitStdoutLines()

    def writeStdinLine(self, line):
        socketio.emit('replstdout', '>> ' + line + '\n', namespace='/')
        self.process.stdin.write(line + '\n')

    def emitStdoutLines(self):
        while True:
            sleep(self.delay)
            try:
                line = self.process.stdout.readline()
            except:
                continue
            if line:
                # TODO fix 
                # log("emitting line: '%s'" % line.strip())
                line = sub(r'^(>> )*', '', line)
                socketio.emit('replstdout', line, namespace='/')

###################
# flask webserver #
###################

app = Flask(__name__)
app.config['SECRET_KEY'] = 'so-secret!'
login = LoginManager(app)
Session(app)
socketio = SocketIO(app, manage_session=False, logger=True, engineio_logger=True)

@app.route('/')
def index():
    # cookie is set here because we're making an http response anyway
    resp = make_response(render_template('index.html'))
    ssid = get_sessionid()
    if not 'shortcut-session-id' in request.cookies:
        resp.set_cookie('shortcut-session-id', ssid)
    return resp

def get_sessionid():
    # cookie should have been see in index() already, unless called from there
    try:
        return request.cookies['shortcut-session-id']
    except:
        ssid = uuid4().hex
        return ssid

@socketio.on('connect')
def handle_connect():
    # cookie should have been set in index() already
    ssid = get_sessionid()
    print('client %s connected' % ssid)
    global shortcut_threads
    if not ssid in shortcut_threads:
        shortcut_threads[ssid] = ShortcutThread(ssid)
    thread = shortcut_threads[ssid]
    if not thread.isAlive():
        thread.start()

@socketio.on('replstdin')
def handle_replstdin(line):
    ssid = get_sessionid()
    repl = shortcut_threads[ssid]
    log("passing line '%s' to repl %s" % (line, repl))
    ssid = get_sessionid()
    thread = shortcut_threads[ssid]
    thread.writeStdinLine(line)

@socketio.on('comment')
def handle_comment(comment):
    ssid = get_sessionid()
    log("client %s submitted a comment: '%s'" % (ssid, comment))
    filename = join('comments', '%s_%s.txt' % (timestamp(), ssid))
    with open(filename, 'w') as f:
        f.write(comment.encode('utf-8'))

if __name__ == '__main__':
    socketio.run(app)
