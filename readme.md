shortcut-web
============

A relatively simple test server for [ShortCut][1]!

Install
-------

For the python server, do this:

```.bash
virtualenv .venv
source .venv/bin/activate
pip install flask-socketio gevent
FLASK_APP=server.py FLASK_ENV=development flask run
```

Then visit `client.html` in your browser.

When doing a demo, be sure to remove the development flag.
SocketIO is much more stable without it!

[1]: https://github.com/jefdaj/shortcut