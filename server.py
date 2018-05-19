#!/usr/bin/env python2

# TODO fix "new session on refresh" error

from datetime       import datetime
from flask          import Flask, render_template, session, request
from flask_login    import LoginManager
from flask_session  import Session
from flask_socketio import SocketIO, emit

# see https://blog.miguelgrinberg.com/post/flask-socketio-and-the-user-session
app = Flask(__name__)
app.config['SECRET_KEY'] = 'so-secret!'
app.config['SESSION_TYPE'] = 'filesystem'
# app.config['PERMANENT_SESSION_LIFETIME'] = 60 * 60 * 24 # one day
# app.config.from_object(__name__)
login = LoginManager(app)
# Session(app)
# socketio = SocketIO(app, manage_session=False)
socketio = SocketIO(app)

# a shortcut interpreter for each currently connected client
# TODO periodically remove idle ones, or what?
# TODO shut them all down on server exit
# TODO delete the files, or leave them for a while probably?
interpreters = {}

def timestamp():
    return datetime.today().strftime('%Y-%m-%d %H:%M:%S')

def log(msg):
    print '[%s] %s' % (timestamp(), msg)

def launch_shortcut(sid):
    sci = '<shortcut %s>' % sid
    log('launching %s' % sci)
    return sci

# TODO basically these don't work... is there a more reliable way?
# @socketio.on('connect')
# def handle_connect():
#     sid = request.sid
#     session['sid'] = sid
#     log('client %s connected' % sid)
#     global interpreters
#     if sid in interpreters:
#         log('use existing interpreter %s' % interpreters[sid])
#     else:
#         interpreters[sid] = launch_shortcut(sid)
#     log('interpreters: %s' % interpreters)
# 
# @socketio.on('disconnect')
# def handle_disconnect():
#     # TODO any way to make this a reliable indicator of being done?
#     log('client %s disconnected' % session['sid'])

@socketio.on('repl input')
def handle_repl_input(msg):

    try:
        sid = session['sid']
    except KeyError:
        sid = request.sid
        log('failed to get sid. creating a new one from the current request: %s' % sid)
        session['sid'] = sid
        log('client %s connected' % sid)
        interpreters[sid] = launch_shortcut(sid)
    log('interpreters: %s' % interpreters)

    log("client %s sent a line of repl input: '%s'" % (sid, msg))
    emit('append message', "&gt;&gt;" + msg + "<br/>")
    log("passing '%s' to %s" % (msg, interpreters[sid]))

@socketio.on('comment')
def handle_comment(msg):
        log("client %s submitted a comment: '%s'" % (session['sid'], msg))

if __name__ == '__main__':
    socketio.run(app, debug=True)
