#!/usr/bin/env python2

# TODO thank that guy for the random numbers example that fixed the bug
# TODO repl should respawn when it crashes or is exited

from datetime       import datetime
from flask          import Flask, render_template, request, make_response
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

threads = {}

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
        self.emitStdout()

    def emitLine(self, line):
        socketio.emit('replstdout', line, namespace='/', room=self.sessionid)

    def readLine(self, line):
        self.emitLine('>> ' + line + '\n')
        self.process.stdin.write(line + '\n')

    def emitStdout(self):
        while True:
            sleep(self.delay)
            try:
                line = self.process.stdout.readline()
            except:
                continue
            if line:
                line = sub(r'^(>> )*', '', line)
                self.emitLine(line)

#############
# webserver #
#############

app = Flask(__name__)
app.config['SECRET_KEY'] = 'so-secret!'
socketio = SocketIO(app, manage_session=False, logger=True, engineio_logger=True)

@app.route('/')
def index():
    return render_template('index.html')

@socketio.on('connect')
def handle_connect():
    sid = request.sid
    print('client %s connected' % sid)
    global threads
    if not sid in threads:
        threads[sid] = ShortcutThread(sid)
    thread = threads[sid]
    if not thread.isAlive():
        thread.start()

@socketio.on('replstdin')
def handle_replstdin(line):
    threads[request.sid].readLine(line)

@socketio.on('comment')
def handle_comment(comment):
    sid = request.sid
    log("client %s submitted a comment: '%s'" % (sid, comment))
    filename = join('comments', '%s_%s.txt' % (timestamp(), sid))
    with open(filename, 'w') as f:
        f.write(comment.encode('utf-8'))

if __name__ == '__main__':
    socketio.run(app)
