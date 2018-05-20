#!/usr/bin/env python2

# TODO when things break, check in case Firefox just needs a restart!

from datetime       import datetime
from flask          import Flask, render_template, session, request, make_response, copy_current_request_context
from flask_login    import LoginManager
from flask_session  import Session
from flask_socketio import SocketIO, emit
from os.path        import join, realpath
from subprocess     import Popen, PIPE, STDOUT
from threading      import Lock, Thread, Event
from uuid           import uuid4

from random import random
from time import sleep

#######################
# random numbers test #
#######################

thread = Thread()
thread_stop_event = Event()

class RandomThread(Thread):
    def __init__(self):
        self.delay = 1
        super(RandomThread, self).__init__()

    def randomNumberGenerator(self):
        """
        Generate a random number every 1 second and emit to a socketio instance (broadcast)
        Ideally to be run in a separate thread?
        """
        #infinite loop of magical random numbers
        print("Making random numbers")
        while not thread_stop_event.isSet():
            number = round(random()*10, 3)
            print(number)
            # socketio.emit('newnumber', {'number': number}, namespace='/')
            socketio.emit('newnumber', {'number': number})
            sleep(self.delay)

    def run(self):
        self.randomNumberGenerator()

##############################
# control shortcut instances #
##############################

# a shortcut interpreter for each session
# TODO periodically remove idle ones, or what?
# TODO shut them all down on server exit
# TODO make this object-oriented?
# for now, it's a list of dicts
interpreters = {}
interpreters_lock = Lock()

def new_interpreter(ssid):
    'create a new interpreter and add it to the global map'
    global interpreters
    global interpreters_lock
    # TODO is this right? maybe there's a specific threadsafe list type instead
    with interpreters_lock:
        log('launching new interpreter %s' % ssid)
        sci = {'ssid': ssid, 'tmpdir': join(realpath('shortcut_session'), ssid)}
        cmd = ['shortcut', '--interactive', '--tmpdir', sci['tmpdir']]
        # TODO should this go in the background worker too? and be repeated?
        # TODO would pty help here? there must be a reason for it
        #      (don't try until the main avenue doesn't work out)
        sci['process'] = Popen(cmd, stdin=PIPE, stdout=PIPE, stderr=STDOUT, bufsize=0)
        interpreters[ssid] = sci
        emit_repl_output(sci)

def get_interpreter(ssid):
    'get an interpreter by shortcut-session-id, creating it if needed'
    # TODO can the other calls be removed now?
    if not ssid in interpreters:
        new_interpreter(ssid)
    return interpreters[ssid]

def text_to_html(line):
    # TODO need proper escaping here or there will be errors!
    return line.replace('\n', "<br/>").replace('>>', '&#8811;&nbsp;')

def send_repl_input(sci, line):
    'look up the proper interpreter and pass it a line of input'
    log("passing '%s' to interpreter %s" % (line, sci))
    # emit('repl output', "&#8811;&nbsp;" + line.replace('\n', "<br/>"))
    sci['process'].stdin.write(line + '\n')
    line = text_to_html(line)

    # TODO ok the problem for now is pretty specific: need to emit from a background thread
    # things to try:
    # https://github.com/shanealynn/async_flask/blob/master/application.py
    # python3
    # celery
    # gevent
    # threading
    # closures
    # copy request context with decorator

    # works:
    emit('repl output', line) # from proper request context in main thread

    # does not work:
    # socketio.emit('repl output', line, room=sci['ssid'])

def emit_repl_output(sci):
    # @copy_current_request_context
    def worker():
        for line in sci['process'].stdout:
            line = text_to_html(line)
            socketio.emit('repl output', line, room=sci['ssid'])
            log("emitted line: '%s'" % line)

    # this is what you're supposed to use but it doesn't work at all?
    # TODO wait actually it does, just the same not-emitting issue as with Thread
    socketio.start_background_task(target=worker)

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
socketio = SocketIO(app, manage_session=False, logger=True, engineio_logger=True)

def timestamp():
    #TODO add microseconds after a comma for debugging
    return datetime.today().strftime('%Y-%m-%d_%H:%M:%S')

def log(msg):
    print '%s %s' % (timestamp(), msg)

def get_session_id():
    # note that the cookie is set separately by index()
    try:
        return request.cookies['shortcut-session-id']
    except:
        ssid = uuid4().hex
        log('new client session %s' % ssid)
        get_interpreter(ssid)
        return ssid

# TODO is this getting called multiple times?
@socketio.on('connect')
def handle_new_connection():
    'starts an interpreter immediately when a new client connects'
    # ssid = get_session_id()
    # sci = get_interpreter(ssid)

    # random numbers test:
    # need visibility of the global thread object
    global thread
    print('Client connected')
    #Start the random number generator thread only if the thread has not been started before.
    if not thread.isAlive():
        print("Starting Thread")
        thread = RandomThread()
        thread.start()


@socketio.on('disconnect')
def test_disconnect():
    print('Client disconnected')

@socketio.on('repl input')
def handle_repl_input(msg):
    ssid = get_session_id()
    log("client %s sent a line of repl input: '%s'" % (ssid, msg))
    sci  = get_interpreter(ssid) # TODO do this immediately on first page load?
    send_repl_input(sci, msg)

@socketio.on('comment')
def write_comment(msg):
    ssid = get_session_id()
    log("client %s submitted a comment: '%s'" % (ssid, msg))
    filename = join('comments', '%s_%s.txt' % (timestamp(), ssid))
    with open(filename, 'w') as f:
        f.write(msg)

@app.route('/')
def index():
    # resp = make_response(render_template('index.html'))
    return render_template('index.html')

    # TODO any need to set the cookie elsewhere too?
    #ssid = get_session_id()
    #if not 'shortcut-session-id' in request.cookies:
    #     resp.set_cookie('shortcut-session-id', ssid)

    # log('interpreters: %s' % interpreters)
    #return resp

if __name__ == '__main__':
    socketio.run(app)
