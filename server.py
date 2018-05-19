#!/usr/bin/env python2

# TODO fix "new session on refresh" error
# TODO maybe it'll work if flask itself is serving the page rather than my separate html thing?

from datetime       import datetime
from flask          import Flask, render_template, session, request, make_response
from flask_login    import LoginManager
from flask_session  import Session
from flask_socketio import SocketIO, emit
from uuid           import uuid4
from os.path        import join

# see https://blog.miguelgrinberg.com/post/flask-socketio-and-the-user-session
app = Flask(__name__)
app.config['SECRET_KEY'] = 'so-secret!'
app.config['SESSION_TYPE'] = 'filesystem'
# app.config['PERMANENT_SESSION_LIFETIME'] = 60 * 60 * 24 # one day
# app.config.from_object(__name__)
login = LoginManager(app)
Session(app)
socketio = SocketIO(app, manage_session=False)

# a shortcut interpreter for each session
# TODO periodically remove idle ones, or what?
# TODO shut them all down on server exit
interpreters = {}

def timestamp():
    return datetime.today().strftime('%Y-%m-%d_%H:%M:%S')

def log(msg):
    print '%s %s' % (timestamp(), msg)

def get_session_id():
    # note that the cookie is set separately by index()
    # TODO should the interpreter also be started immediately here?
    try:
        return request.cookies['shortcut-session-id']
    except KeyError:
        ssid = uuid4().hex
        log('new client session %s' % ssid)
        return ssid

def get_interpreter(ssid):
    global interpreters
    if not ssid in interpreters:
        sci = '<shortcut %s>' % ssid
        log('new interpreter %s' % sci)
        interpreters[ssid] = sci
    return interpreters[ssid]

@socketio.on('repl input')
def handle_repl_input(msg):
    #ssid = request.cookies['shortcut-session-id']
    ssid = get_session_id()
    log("client %s sent a line of repl input: '%s'" % (ssid, msg))
    sci  = get_interpreter(ssid)
    emit('append message', "&gt;&gt;" + msg + "<br/>")
    log("passing '%s' to %s" % (msg, sci))

@socketio.on('comment')
def write_comment(msg):
    ssid = get_session_id()
    log("client %s submitted a comment: '%s'" % (ssid, msg))
    filename = join('comments', '%s_%s.txt' % (timestamp(), ssid))
    with open(filename, 'w') as f:
        f.write(msg)

@app.route('/')
def index():
    resp = make_response(render_template('index.html'))

    # TODO any need to set the cookie elsewhere too?
    ssid = get_session_id()
    if not 'shortcut-session-id' in request.cookies:
        resp.set_cookie('shortcut-session-id', ssid)

    log('interpreters: %s' % interpreters)
    return resp

if __name__ == '__main__':
    socketio.run(app)
