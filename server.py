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

@socketio.on('send line')
def handle_send_line(json):
        print('received a line of input: ' + str(json))
        emit('append message', str(json))

if __name__ == '__main__':
    socketio.run(app)
