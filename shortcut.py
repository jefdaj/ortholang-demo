#!/usr/bin/env python2

# TODO fix "new session on refresh" error
# TODO maybe it'll work if flask itself is serving the page rather than my separate html thing?

from datetime       import datetime
from flask          import Flask, render_template, session, request, make_response
from flask_login    import LoginManager
from flask_session  import Session
from flask_socketio import SocketIO, emit
from uuid           import uuid4
from os.path        import join, realpath
from threading      import Lock

##############################
# control shortcut instances #
##############################

# TODO make this a thread directly, or better for it to have a reference to one?
# class ShortCutInstance(object):
#     def __init__(self, ssid):
#         self.ssid = ssid # TODO is this needed?
#         self.lock = Lock()
#         self.proc = None
# 
#     def init_interpreter(self):
#         with self.lock:
#             if self.proc is None:
#                 pass # TODO write this

# a shortcut interpreter for each session
# TODO periodically remove idle ones, or what?
# TODO shut them all down on server exit
# TODO make this object-oriented?
# for now, it's a list of dicts
interpreters = {}
interpreters_lock = Lock()

def run_shortcut(sci):
    # TODO should be able to do this in a loop right?
    #with app.app_context():
    # with app.app_context():
    # emit("repl output", "output from shortcut repl goes here", room=sci['ssid'])
        # emit("repl output", "output from shortcut repl goes here")
    # sleep(5)
    return

def new_interpreter(ssid):
    'create a new interpreter and add it to the global map'
    global interpreters
    global interpreters_lock
    # TODO is this right? maybe there's a specific threadsafe list type instead
    with interpreters_lock:
        log('launching new interpreter %s' % ssid)
        sci = {'ssid': ssid, 'tmpdir': join(realpath('interpreters'), ssid)}
        #run_shortcut(sci)
        interpreters[ssid] = sci

def get_interpreter(ssid):
    'get an interpreter by shortcut-session-id, creating it if needed'
    # TODO can the other calls be removed now?
    if not ssid in interpreters:
        new_interpreter(ssid)
    return interpreters[ssid]

def pass_line_to_repl(ssid, line):
    'look up the proper interpreter and pass it a line of input'
    sci = get_interpreter(ssid)

#####################
# serve the webpage #
#####################

# see https://blog.miguelgrinberg.com/post/flask-socketio-and-the-user-session
app = Flask(__name__)
app.config['SECRET_KEY'] = 'so-secret!'
app.config['SESSION_TYPE'] = 'filesystem'
# app.config['PERMANENT_SESSION_LIFETIME'] = 60 * 60 * 24 # one day
# app.config.from_object(__name__)
login = LoginManager(app)
Session(app)
# socketio = SocketIO(app, manage_session=False, async_mode='gevent')
socketio = SocketIO(app, manage_session=False)

def timestamp():
    #TODO add microseconds after a comma for debugging
    return datetime.today().strftime('%Y-%m-%d_%H:%M:%S')

def log(msg):
    print '%s %s' % (timestamp(), msg)

def get_session_id():
    # note that the cookie is set separately by index()
    # TODO should the interpreter also be started immediately here?
    try:
        return request.cookies['shortcut-session-id']
    except:
        ssid = uuid4().hex
        log('new client session %s' % ssid)
        get_interpreter(ssid)
        return ssid

@socketio.on('connect')
def handle_new_connection():
    'starts an interpreter immediately when a new client connects'
    ssid = get_session_id()
    get_interpreter(ssid)

@socketio.on('repl input')
def handle_repl_input(msg):
    #ssid = request.cookies['shortcut-session-id']
    ssid = get_session_id()
    log("client %s sent a line of repl input: '%s'" % (ssid, msg))
    sci  = get_interpreter(ssid) # TODO do this immediately on first page load?
    emit('repl output', "&#8811;&nbsp;" + msg + "<br/>")
    log("passing '%s' to interpreter %s" % (msg, sci))

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
