#!/usr/bin/env python2

from flask import Flask, render_template
from flask_socketio import SocketIO, emit

app = Flask(__name__)
app.config['SECRET_KEY'] = 'secret!'
socketio = SocketIO(app)

@socketio.on('connect')
def handle_connect():
    # emit('my response', {'data': 'Connected'})
    print('Client connected')

@socketio.on('disconnect')
def handle_disconnect():
    print('Client disconnected')

@socketio.on('repl input')
def handle_repl_input(msg):
        print("received a line of repl input: '%s'" % msg)
        emit('append message', "&gt;&gt;" + msg + "<br/>")

@socketio.on('comment')
def handle_comment(msg):
        print("received a comment: '%s'" % msg)
        # emit('append message', "&gt;&gt;" + msg + "<br/>")

if __name__ == '__main__':
    socketio.run(app)
