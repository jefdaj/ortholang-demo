#!/usr/bin/env python2

from flask import Flask, render_template
from flask_socketio import SocketIO

app = Flask(__name__)
app.config['SECRET_KEY'] = 'secret!'
socketio = SocketIO(app)

@socketio.on('client connected')
def handle_client_connected(msg):
        print('client connected. data: ' + str(msg))

if __name__ == '__main__':
    socketio.run(app)
