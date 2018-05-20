shortcut-web
============

A relatively simple test server for [ShortCut][1]!

Install
-------

For the python server, do this:

```.bash
virtualenv .venv
source .venv/bin/activate
pip install flask flask-socketio flask-login flask-session
./shortcut.py
```

Then visit `localhost:5000` in your browser.

Note: do *not* install actual websockets stuff (gevent, eventlets, etc) as that seems to break it.

[1]: https://github.com/jefdaj/shortcut
