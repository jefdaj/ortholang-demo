#!/usr/bin/env python2

# TODO hardcode data dir? make it a separate nix expression? use string path to repo?
# TODO draw a better logo with a map? later for the paper
# TODO thank that guy for the random numbers example that fixed the bug
# TODO should users dir be optional?

'''
Launch the ShortCut demo server.

Usage:
  shortcut-demo (-h | --help)
  shortcut-demo -l LOG -d DATA -c COMMENTS -u UPLOADS -t TMP -p PORT -a AUTH -s USERS

Options:
  -h, --help   Show this help text
  -l LOG       Path to the log file
  -d DATA      Path to the data directory
  -c COMMENTS  Path to the user comments directory
  -u UPLOADS   Path to the user uploads directory
  -t TMP       Path to the user tmpdirs
  -p PORT      Port to serve the demo site
  -a AUTH      Path to user authentication file
  -s USERS     Path to user data directory
'''

import logging as LOGGING

from datetime            import datetime
from docopt              import docopt
from flask               import Flask, render_template, request, make_response, send_from_directory
from flask_misaka        import Misaka
from flask_socketio      import SocketIO, emit
from flask_httpauth      import HTTPBasicAuth
from glob                import glob
from jinja2              import ChoiceLoader, FileSystemLoader
from misaka              import Markdown, HtmlRenderer
from os                  import setsid, getpgid, killpg, makedirs, symlink
from os.path             import exists, join, realpath, dirname, basename, splitext
from psutil              import cpu_percent, virtual_memory
from pygments            import highlight
from pygments.formatters import HtmlFormatter, ClassNotFound
from pygments.lexers     import PythonLexer
from re                  import sub, DOTALL
from shutil              import rmtree
from signal              import SIGKILL
from subprocess          import Popen, PIPE, STDOUT
from threading           import Thread, Event
from time                import sleep
from twisted.internet    import reactor as REACTOR
from twisted.web.server  import Site
from twisted.web.wsgi    import WSGIResource
from uuid                import uuid4


##########
# config # 
##########

ARGS = docopt(__doc__)
CONFIG = {}
CONFIG['data_dir'   ] = realpath(ARGS['-d'])
CONFIG['log_path'   ] = realpath(ARGS['-l'])
CONFIG['comment_dir'] = realpath(ARGS['-c'])
CONFIG['upload_dir' ] = realpath(ARGS['-u'])
CONFIG['tmp_dir'    ] = realpath(ARGS['-t'])
CONFIG['auth_path'  ] = realpath(ARGS['-a'])
CONFIG['users_dir'  ] = realpath(ARGS['-s'])
CONFIG['port'       ] = int(ARGS['-p'])


###########
# logging #
###########

# see https://www.blog.pythonlibrary.org/2012/08/02/python-101-an-intro-to-logging/
# all modules will use this
HANDLER = LOGGING.FileHandler(CONFIG['log_path'])
HANDLER.setFormatter(LOGGING.Formatter('%(asctime)s %(name)s %(levelname)s %(message)s'))

# set up logging for this module
# note: socketio + engineio loggers are messed with later
LOGGER = LOGGING.getLogger('shortcut')
LOGGER.setLevel(LOGGING.INFO)
LOGGER.addHandler(HANDLER)
LOGGER.info('starting demo.py')

def timestamp():
    return datetime.today().strftime('%Y-%m-%d_%H:%M:%S')


###############
# server load #
###############

class ServerLoadThread(Thread):
    def __init__(self):
        self.delay = 5
        self.n_sessions= 0
        super(ServerLoadThread, self).__init__()
        self.daemon = True

    def run(self):
        LOGGER.info('starting ServerLoadThread')
        while True:
            self.emitInfo()
            sleep(self.delay)

    def emitInfo(self):
        if self.n_sessions > 0:
            cpu = round(cpu_percent())
            mem = round(virtual_memory().percent)
            nfo = {'users': self.n_sessions, 'cpu': cpu, 'memory': mem}
            LOGGER.info('emitting serverload: %s' % nfo)
            SOCKETIO.emit('serverload', nfo, namespace='/')

    def sessionStarted(self):
        self.n_sessions += 1

    def sessionEnded(self):
        self.n_sessions -= 1

# this is started later because it needs SOCKETIO
LOAD = ServerLoadThread()


##########
# misaka #
##########

class HighlighterRenderer(HtmlRenderer):
    def blockcode(self, text, lang):
        return highlight(text, PythonLexer(), HtmlFormatter())

MARKDOWN = Markdown(HighlighterRenderer(),
                    extensions=('highlight', 'fenced-code', 'tables'))

# used to render the code examples
# LOGGER.info('rendering example cut scripts')
CODEBLOCKS = {}
for path in glob(join(CONFIG['data_dir'], '*.cut')) + glob(join(CONFIG['users_dir'], '*/*.cut')):
    with open(path, 'r') as f:
        txt = '```\n%s\n```\n' % f.read()
        name = basename(path)
    CODEBLOCKS[name] = {'id': name.replace('.', '_'), 'path': path, 'content': MARKDOWN(txt)}

# for the load script menu
CODEBLOCK_NAMES = ['examples/' + basename(k) for k in CODEBLOCKS.keys()]
CODEBLOCK_NAMES.sort()


##################
# authentication #
##################

AUTH = HTTPBasicAuth()
AUTH_USERS = {}

with open(CONFIG['auth_path'], 'r') as f:
    for line in f.readlines():
        u = line.split()[0] # TODO is this right?
        p = line.split()[1] # TODO is this right?
        AUTH_USERS[u] = p

@AUTH.verify_password
def verify_pw(username, password):
    global AUTH_USERS
    if not username in AUTH_USERS:
        # go ahead and create it, as long as some password given
        if len(password) == 0: #TODO require good passwords?
            return False
        create_user(username, password)
    return password == AUTH_USERS[username]

def create_user(username, password):
    # note this assumes the username isn't taken!
    # also that a user is different from a SessionUser, which might not have a username
    LOGGER.info("creating user '%s' with password '%s'" % (username, password))
    global AUTH_USERS
    AUTH_USERS[username] = password
    with open(CONFIG['auth_path'], 'a') as f:
        f.write('%s\t%s\n' % (username, password))


#########
# flask #
#########

SRCDIR = join(dirname(dirname(__file__))) # when testing in nix-shell
if exists(join(SRCDIR, 'src')): # when in the final package
  SRCDIR = join(SRCDIR, 'src')

FLASK = Flask(__name__,
             template_folder=join(SRCDIR,'templates'),
             static_folder=join(SRCDIR, 'static'))

FLASK.jinja_loader = ChoiceLoader([FLASK.jinja_loader, FileSystemLoader(CONFIG['users_dir'])])

# see https://github.com/tlatsas/jinja2-highlight
# jinja_options.setdefault('extensions', []).append('jinja2_highlight.HighlightExtension')
# FLASK.jinja_options = jinja_options
# FLASK.jinja_env.extend(jinja2_highlight_cssclass = 'codehilite')

FLASK.config['SECRET_KEY'] = 'so-secret!'
Misaka(FLASK, tables=True, fenced_code=True, highlight=True)

# this is a single-page app so only the one route
@FLASK.route('/')
def guest():
    return render_template('index.html', user='guest', codeblocks=CODEBLOCKS, codeblock_names=CODEBLOCK_NAMES)

# ... but a second entry point helps with authenticated content
@FLASK.route('/user')
@AUTH.login_required
def user():
    user = AUTH.username()
    return render_template('index.html', user=user, codeblocks=CODEBLOCKS, code_names=CODEBLOCK_NAMES)

# Flask doesn't like sending random files from all over for security reasons,
# so we make these simplified routes where /TMPDIR and /WORKDIR refer to their ShortCut equivalents.
# Lines from ShortCut get rewritten with regexes to include that (messy I know),
# and then this function finds the real paths again when we need to fetch a file.
@FLASK.route('/TMPDIR/<path:filename>')
def send_tmpfile(filename):
    filename = with_real_paths(filename)
    LOGGER.info('sending tmpfile: %s' % filename)
    # return send_file(filename)
    return send_from_directory(dirname(filename), basename(filename))

@FLASK.route('/img/<path:filename>')
def get_image(filename):
    filename = '/' + filename
    LOGGER.info("sending image: '%s'" % filename)
    return send_from_directory(dirname(filename), basename(filename), mimetype='image/png')

def with_real_paths(sid, line):
    repl = SESSIONS[sid]
    # print "line before: '%s'" % line
    line = sub('/TMPDIR' , repl.tmpdir , line)
    line = sub('/WORKDIR', repl.workdir, line)
    # print "line after: '%s'" % line
    return line

############
# socketio #
############

SOCKETIO = SocketIO(FLASK, manage_session=False, logger=True, engineio_logger=True)
LOAD.start()

# swap other modules' log handlers for mine
LOGGING.getLogger('socketio').handlers = []
LOGGING.getLogger('socketio').addHandler(HANDLER)
LOGGING.getLogger('engineio').handlers = []
LOGGING.getLogger('engineio').addHandler(HANDLER)

@SOCKETIO.on('connect')
def handle_connect():
    sid = request.sid
    LOGGER.info('client %s connected' % sid)
    global SESSIONS
    if not sid in SESSIONS:
        uname = AUTH.username()
        if not uname:
            uname = 'guest'
        SESSIONS[sid] = ShortcutThread(sid, uname)
    thread = SESSIONS[sid]
    if not thread.isAlive():
        thread.start()

@SOCKETIO.on('disconnect')
def handle_disconnect():
    LOGGER.info('client %s disconnected' % request.sid)
    global LOAD
    LOAD.sessionEnded()
    thread = SESSIONS[request.sid]
    thread._done.set()
    thread.killRepl()

@SOCKETIO.on('replstdin')
def handle_replstdin(line):
    SESSIONS[request.sid].readLine(line)

@SOCKETIO.on('replkill')
def handle_replkill():
    SESSIONS[request.sid].stopEval()

@SOCKETIO.on('comment')
def handle_comment(comment):
    sid = request.sid
    LOGGER.info("client %s submitted a comment: '%s'" % (sid, comment))
    filename = join(CONFIG['comment_dir'], '%s_%s.txt' % (timestamp(), sid))
    with open(filename, 'w') as f:
        f.write(comment.encode('utf-8'))

# TODO put uploads in a separate user folder
# TODO allow uploads of other file types too, not just .cut
# TODO detect whether uploaded file was .cut and update menu
#      (need to avoid incorrectly :loading non-cut files)
@SOCKETIO.on('upload')
def handle_upload(data):
    sid = request.sid
    LOGGER.info("client %s uploaded a file: '%s'" % (sid, data['fileName']))
    # TODO some kind of check and/or put in separate uploads folder
    # TODO get root dir from FLASK
    # TODO or pass data dir
    filename = join(CONFIG['data_dir'], data['fileName'])
    with open(filename, 'w') as f:
        f.write(data['fileData'])
    LOGGER.info("saved user file '%s'" % filename)

@SOCKETIO.on('reqscript')
def handle_reqscript(data):
    # TODO autosave script before downloading maybe-old version?
    name = data['fileName']
    LOGGER.info("client %s requested script download (name: '%s')" % (request.sid, name))
    repl = SESSIONS[request.sid]
    path = join(repl.workdir, name)
    LOGGER.info("sending '%s' to client %s" % (path, request.sid))
    with open(path, 'r') as f:
        txt = f.read()
    SOCKETIO.emit('dlscript', {'scriptName': name, 'scriptText': txt})

@SOCKETIO.on('reqresult')
def handle_reqresult():
    sid = request.sid
    LOGGER.info("client %s requested result download" % sid)
    path = join(SESSIONS[sid].tmpdir, 'vars/result')
    LOGGER.info("sending '%s' to client %s" % (path, request.sid))
    with open(path, 'r') as f:
        txt = f.read()
    # TODO what about when the result is an image? have them save as for now i guess
    # TODO how to not log the entire result file?
    SOCKETIO.emit('dlresult', {'resultName': 'result', 'resultText': txt})


############
# shortcut #
############

class ShortcutThread(Thread):
    def __init__(self, sessionid, username):
        LOGGER.info('creating session %s' % sessionid)
        self.delay = 0.01
        self.sessionid = sessionid
        self.username  = username
        user_dir = join(CONFIG['users_dir'], self.username)
        if exists(user_dir):
            self.workdir = user_dir
            self.tmpdir  = join(self.workdir, 'tmpdir')
        else:
            self.tmpdir  = join(CONFIG['tmp_dir'], sessionid)
            self.workdir = join(self.tmpdir, 'data')
            makedirs(self.workdir)
        try:
            symlink(CONFIG['data_dir'], join(self.workdir, 'examples')) # TODO rename data examples?
        except OSError:
            pass # already exists
        self._done = Event()
        self.process = None
        # self.spawnRepl()
        super(ShortcutThread, self).__init__()

    def run(self):
        global LOAD
        LOAD.sessionStarted()
        while not self._done.is_set():
            self.spawnRepl()
            self.emitStdout()
        LOAD.sessionEnded()

    # TODO currently this is the same as killing the interpreter... handle separately in shortcut?
    def stopEval(self):
        LOGGER.info('session %s stopping %s evaluation' % (self.sessionid, self.process.pid))
        self.killRepl()
        self.emitLine('Resetting demo...\n')
        self.spawnRepl()
        # self.readLine('')

    def killRepl(self):
        # see https://stackoverflow.com/a/22582602
        LOGGER.info('session %s killing interpreter %s' % (self.sessionid, self.process.pid))
        try:
            pgid = getpgid(self.process.pid)
            killpg(pgid, SIGKILL)
            self.process.wait()
        except:
            pass
        finally:
            if self.username == 'guest':
                rmtree(self.tmpdir, ignore_errors=True)

    def spawnRepl(self):
        if self.process is not None:
            self.killRepl()
        cmd = ['shortcut', '--secure', '--interactive',
               '--tmpdir', self.tmpdir, '--workdir', self.workdir]
        self.process = Popen(cmd, stdin=PIPE, stdout=PIPE, stderr=STDOUT, preexec_fn=setsid)
        LOGGER.info('session %s spawned interpreter %s' % (self.sessionid, self.process.pid))

    def emitLine(self, line):
        # hack to show images in the repl
        # TODO also hack it to show them one per line
        # TODO ... and with list brackets?
        old = ".*plot image '(.*?)'.*"
        new = r' <img src="/img\1" style="max-width: 400px;"></img> '
        line = sub(old, new, line, flags=DOTALL)

        if not '<img' in line:
            # rewrites tmpdir and workdir paths for simpler routes
            # see find_real_filename for the rationale + undoing it
            # print "line before: '%s'" % line
            line = sub(self.workdir, '/WORKDIR', line)
            line = sub(self.tmpdir , '/TMPDIR' , line)
            # print "line after: '%s'" % line

        SOCKETIO.emit('replstdout', line, namespace='/', room=self.sessionid)

    def readLine(self, line):
        try:
            line = line.strip()
            self.process.stdin.write(line + '\n')
            self.emitLine('>> ' + line + '\n')
            if '=' in line or line.startswith(':') or line.startswith('#') or len(line) == 0:
                # repl commands are generally instant, but don't print a newline
                # so to help it along with auto-reenable
                self.enableInput()
            else:
                # other commands might actually be doing work
                # so we disable until they print something
                self.disableInput()
        except IOError:
            if not self._done.is_set():
                self.stopEval()
                sleep(2)
                self.readLine(line)

    def disableInput(self):
        SOCKETIO.emit('replbusy', namespace='/', room=self.sessionid)

    def enableInput(self):
        SOCKETIO.emit('replready', namespace='/', room=self.sessionid)

    def emitStdout(self):
        while True:
            sleep(self.delay) # TODO remove? decrease?
            try:
                line = self.process.stdout.readline()
            except:
                break
            if line:
                self.enableInput() # TODO what about when about to print more lines?
                line = sub(r'^(>> )*', '', line)
                self.emitLine(line)

SESSIONS = {}


###########
# twisted #
###########

# this is based on https://gist.github.com/ianschenck/977379a91154fe264897
# but I had trouble getting the reloader to work without zombie processes

RESOURCE = WSGIResource(REACTOR, REACTOR.getThreadPool(), FLASK)
SITE = Site(RESOURCE)
REACTOR.listenTCP(CONFIG['port'], SITE)
REACTOR.run(installSignalHandlers=True)
