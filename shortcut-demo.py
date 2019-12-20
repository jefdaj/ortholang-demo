#!/usr/bin/env python2
# coding: utf8
# vim: set fileencoding=utf-8

# TODO hardcode data dir? make it a separate nix expression? use string path to repo?
# TODO draw a better logo with a map? later for the paper
# TODO thank that guy for the random numbers example that fixed the bug
# TODO should users dir be optional?

'''
Launch the ShortCut demo server.

Usage:
  shortcut-demo (-h | --help)
  shortcut-demo -l LOG -e EXAMPLES -c COMMENTS -t TMP -p PORT -a AUTH -u USERS -s SHARED

Options:
  -h, --help   Show this help text
  -l LOG       Path to the log file
  -e EXAMPLES  Path to the examples directory
  -c COMMENTS  Path to the user comments directory
  -t TMP       Path to the user tmpdirs
  -p PORT      Port to serve the demo site
  -a AUTH      Path to user authentication file
  -u USERS     Path to user data directory
  -s SHARED    Path to shared tmpfile directory
'''

# see https://stackoverflow.com/a/44951327
import sys
reload(sys)
sys.setdefaultencoding('utf8')

import re
import json
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
from os                  import setsid, getpgid, killpg, makedirs, symlink, readlink, walk
from os.path             import exists, join, relpath, realpath, dirname, basename, splitext
from pexpect             import spawn, EOF
from psutil              import cpu_percent, virtual_memory
from pygments            import highlight
from pygments.formatters import HtmlFormatter, ClassNotFound
from pygments.lexers     import PythonLexer
from shutil              import rmtree
from signal              import SIGKILL
from subprocess          import Popen, PIPE, STDOUT
from threading           import Thread, Event
from time                import sleep
from twisted.internet    import reactor as REACTOR
from twisted.web.server  import Site
from twisted.web.wsgi    import WSGIResource
from uuid                import uuid4
from werkzeug.security   import generate_password_hash, check_password_hash


##########
# config # 
##########

ARGS = docopt(__doc__)
CONFIG = {}
CONFIG['examples_dir'] = realpath(ARGS['-e'])
CONFIG['log_path'    ] = realpath(ARGS['-l'])
CONFIG['comment_dir' ] = realpath(ARGS['-c'])
CONFIG['tmp_dir'     ] = realpath(ARGS['-t'])
CONFIG['auth_path'   ] = realpath(ARGS['-a'])
CONFIG['users_dir'   ] = realpath(ARGS['-u'])
CONFIG['shared_dir'  ] = realpath(ARGS['-s'])
CONFIG['port'        ] = int(ARGS['-p'])

# repl sessions, indexed by sid and also username if logged in
SESSIONS = {}

# prompt arrow, which should match the shortcut code
# ARROW = "❱❱❱ "
# ARROW = "-> " # TODO does it need escaping in regexes?
ARROW = u' —▶ '

SRCDIR = join(dirname(dirname(__file__))) # when testing in nix-shell
if exists(join(SRCDIR, 'src')): # when in the final package
  SRCDIR = join(SRCDIR, 'src')


###########
# logging #
###########

# this quiets flask-socketio + werkzeug
# see https://stackoverflow.com/q/49038678
LOGGING.basicConfig(level=LOGGING.ERROR)

# see https://www.blog.pythonlibrary.org/2012/08/02/python-101-an-intro-to-logging/
# all modules will use this
HANDLER = LOGGING.FileHandler(CONFIG['log_path'])
HANDLER.setFormatter(LOGGING.Formatter('%(asctime)s %(name)s %(levelname)s %(message)s'))

# set up logging for this module
# note: socketio + engineio loggers are messed with later
LOGGER = LOGGING.getLogger('shortcut')
LOGGER.setLevel(LOGGING.DEBUG)
LOGGER.addHandler(HANDLER)
LOGGER.info('starting demo.py')

def timestamp():
    return datetime.today().strftime('%Y-%m-%d_%H:%M:%S')


###############
# server load #
###############

class ServerLoadThread(Thread):
    def __init__(self):
        LOGGER.debug('init ServerLoadThread')
        self.delay = 5
        super(ServerLoadThread, self).__init__()
        self.daemon = True

    def run(self):
        LOGGER.info('starting ServerLoadThread')
        while True:
            self.emitInfo()
            sleep(self.delay)

    def emitInfo(self):
        # counts multiple users connecting under the same account too
        n_sessions = sum(len(u.sessionids) for u in SESSIONS.values())
        if n_sessions == 0:
            return
        cpu = round(cpu_percent())
        mem = round(virtual_memory().percent)
        nfo = {'users': n_sessions, 'cpu': cpu, 'memory': mem}
        LOGGER.debug('emitting serverload: %s' % nfo)
        SOCKETIO.emit('serverload', nfo, namespace='/')
        LOGGER.debug('sessions: %s' % SESSIONS.keys())

# this is started later because it needs SOCKETIO
# TODO why does it count an extra user when you clear the http auth?
#      guess it starts a guest on refresh and doesn't time it out properly? add a timeout
LOAD = ServerLoadThread()


##########
# misaka #
##########

# note: misaka is actually initialized later, in the flask section

class HighlighterRenderer(HtmlRenderer):
    def blockcode(self, text, lang):
        # dtr scripts look decent with python syntax highlighting
        return highlight(text, PythonLexer(), HtmlFormatter())

MARKDOWN = Markdown(HighlighterRenderer(), extensions=('highlight', 'fenced-code', 'tables'))

# def load_codeblock_userpaths(codeblocks):
#     # for the load script menu
#     # TODO use paths instead of basenames
#     # print codeblocks
#     names = [basename(k) for k in codeblocks.keys()]
#     names.sort()
#     #print 'names:', names
#     return names

def find_cuts(dirpath):
    for root, dirs, files in walk(dirpath, followlinks=True):
        # see https://stackoverflow.com/a/19859907
        dirs[:] = [d for d in dirs if not d.startswith('.') and not basename(d) == 'tmpdir']
        for file in files:
            if file.endswith('.cut'):
                yield(join(root, file))

def load_codeblocks():
    # used to render the code examples
    codeblocks = {}
    for path in find_cuts(CONFIG['users_dir']):
        with open(path, 'r') as f:
            txt = '```\n%s\n```\n' % f.read()
            # name = basename(path)
            userpath = relpath(path, CONFIG['users_dir'])
            ruserpath = '/'.join(userpath.split('/')[1:])
        # print 'ruserpath:', ruserpath
        codeblocks[userpath] = \
            { 'id'     : userpath.replace('.', '_').replace('/', '_')
            , 'path'   : userpath
            , 'relpath': ruserpath
            , 'content': MARKDOWN(txt)
            }
    # print codeblocks
    LOGGER.info('loaded codeblocks: %s' % codeblocks.keys())
    return codeblocks

def load_tutorial_sections():
    # used to render the tutorial sections
    sections = {}
    for path in glob(join(SRCDIR, 'templates', 'tutorial_*.md')):
        name = basename(path)
        with open(path, 'r') as f:
            txt = '```\n%s\n```\n' % f.read()
            sections[name] = \
                { 'name': basename(name)
                , 'content': MARKDOWN(txt)
                }
    return sections

def load_genomes():
    # used to render the pre-loaded example genomes
    with open('templates/genomes.json', 'r') as f:
        genomes = json.load(f)
    return genomes


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
    if username == 'guest':
        return False
    if len(password) == 0: # TODO enforce good passwords too?
        return False
    if not username in AUTH_USERS:
        # go ahead and create it
        create_user(username, password)
    return check_password_hash(AUTH_USERS[username], password)

def create_user(username, password):
    # note this assumes the username isn't taken!
    linksrc  = readlink( join(CONFIG['users_dir'], 'guest', 'examples') )
    userpath = join(CONFIG['users_dir'], username)
    try:
        makedirs(userpath)
    except OSError:
        pass
    try:
        symlink(linksrc, join(userpath, 'examples'))
    except OSError:
        pass
    pwhash = generate_password_hash(password)
    LOGGER.info("creating user '%s' with password hash '%s'" % (username, pwhash))
    global AUTH_USERS
    AUTH_USERS[username] = pwhash
    with open(CONFIG['auth_path'], 'a') as f:
        f.write('%s\t%s\n' % (username, pwhash))


#########
# flask #
#########

def list_user_scripts(username):
    # load_code_blocks() # super hacky but reloads code blocks along with templates
    upath = join(CONFIG['users_dir'], username)
    paths = [relpath(p, upath) for p in find_cuts(upath)]
    # paths.sort()
    return paths

FLASK = Flask(__name__, template_folder=join(SRCDIR,'templates'), static_folder=join(SRCDIR, 'static'))
FLASK.config['TEMPLATES_AUTO_RELOAD'] = True
FLASK.jinja_env.globals.update(list_user_scripts=list_user_scripts)
FLASK.jinja_loader = ChoiceLoader([FLASK.jinja_loader, FileSystemLoader(CONFIG['users_dir'])])

# see https://github.com/tlatsas/jinja2-highlight
# jinja_options.setdefault('extensions', []).append('jinja2_highlight.HighlightExtension')
# FLASK.jinja_options = jinja_options
# FLASK.jinja_env.extend(jinja2_highlight_cssclass = 'codehilite')

FLASK.config['SECRET_KEY'] = 'so-secret!'
Misaka(FLASK, tables=True, fenced_code=True, highlight=True)

# this is a single-page app, but has separate routes for guest and authenticated users
# this goes to the guest version
@FLASK.route('/')
def guest():
    return index('guest')

@FLASK.route('/user')
@AUTH.login_required
def user():
    return index(AUTH.username())

def index(user='guest'):
    blocks = load_codeblocks()
    examples    = set(k for k in blocks.keys() if user + '/examples/' in k)
    userscripts = set(k for k in blocks.keys() if k.startswith(user) and not 'examples/' in k)
    sections = load_tutorial_sections()
    genomes = load_genomes()
    # userpaths = load_codeblock_userpaths(blocks)
    return render_template('index.html',
                           user=user,
                           codeblocks=blocks,
                           examples=examples,
                           sections=sections,
                           userscripts=userscripts,
                           genomes=genomes,
                           codeblock_userpaths=blocks.keys())

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
    repl = find_session(sid=sid)
    # print "line before: '%s'" % line
    line = re.sub('/TMPDIR' , repl.tmpdir , line)
    line = re.sub('/WORKDIR', repl.workdir, line)
    # print "line after: '%s'" % line
    return line

# TODO add a path component for the api version?
@FLASK.route('/shared/<path:filename>')
def send_shared(filename):
    filename = join(CONFIG['shared_dir'], filename)
    if not exists(filename):
        msg = 'shared file not found: %s' % filename
        LOGGER.info(msg)
        return msg, 404
    LOGGER.info('sending shared file: %s' % filename)
    return send_from_directory(dirname(filename), basename(filename))

############
# socketio #
############

# can set logger=LOGGER to add socketio debugging to output
SOCKETIO = SocketIO(FLASK, manage_session=False, logger=True, engineio_logger=True)
LOAD.start()

# swap other modules' log handlers for mine
LOGGING.getLogger('socketio').handlers = []
LOGGING.getLogger('socketio').addHandler(HANDLER)
LOGGING.getLogger('engineio').handlers = []
LOGGING.getLogger('engineio').addHandler(HANDLER)

def find_session(sid=None, username=None):
    if sid is None: # TODO is this part needed?
        sid = request.sid
    uname = AUTH.username()
    # print SESSIONS
    if uname and uname in SESSIONS:
        if sid in SESSIONS:
            # remove guest repl because we found their logged in one
            disconnect(sid, 'guest')
        return SESSIONS[uname]
    else:
        return SESSIONS[sid]

def interpret_clear_code(sessionids, sometext):
    # remove terminal escape sequences like "clear screen" in shortcut
    # based on https://stackoverflow.com/a/14693789
    ansi_clear  = re.compile(r'\x1B\[2J')
    ansi_escape = re.compile(r'\x1B\[[0-?]*[ -/]*[@-~]')
    if re.match(ansi_clear, sometext):
        for sid in sessionids:
            SOCKETIO.emit('replclear', namespace='/', room=sid)
    return ansi_escape.sub('', sometext)

@SOCKETIO.on('connect')
def handle_connect():
    sid = request.sid
    uname = AUTH.username()
    LOGGER.info('client %s connected (account: %s)' % (sid, uname))
    # SOCKETIO.emit('replclear')
    global SESSIONS
    if not sid in SESSIONS:
        if not uname:
            LOGGER.info('client %s started a guest session' % sid)
            # print 'trying to start thread...'
            SESSIONS[sid] = ShortCutThread(sid, 'guest')
            # print 'success!'
            thread = SESSIONS[sid]
        else:
            if not uname in SESSIONS:
                LOGGER.info('%s started a new session with id %s' % (uname, sid))
                SESSIONS[uname] = ShortCutThread(sid, uname)
            else:
                LOGGER.info('user %s resuming with new session id %s' % (uname, sid))
                SESSIONS[uname].sessionids.add(sid)
                # SESSIONS[uname].readCommand('# Resuming previous session...')
                SESSIONS[uname].readCommand(':show')
            thread = SESSIONS[uname]
    # print 'thread alive? %s' % thread.isAlive()
    if not thread.isAlive():
        thread.start()

@SOCKETIO.on('pagerefreshed')
def handle_refresh():
    tab = find_session().currenttab
    LOGGER.info('page refreshed; opening tab %s' % tab)
    SOCKETIO.emit('opentab', {'tabName': tab})

@SOCKETIO.on('settab')
def handle_settab(data):
    thread = find_session()
    thread.currenttab = data['tabName']
    LOGGER.info('set current tab of session %s to %s' % (thread.sessionids, data['tabName']))
    # SOCKETIO.emit('opentab', {'tabName': tab})

# TODO why isn't this being called to clean up old guest repls?
#      maybe have to set a socketio timeout?
#      something about how long since the last PING would be nice
@SOCKETIO.on('disconnect')
def handle_disconnect():
    diconnect(request.sid, AUTH.username())

def diconnect(sid, uname):
    LOGGER.info('client %s disconnected' % sid)
    if not uname or uname == 'guest':
        LOGGER.info('killing guest repl %s (account: %s)' % (sid, uname))
        thread = find_session()
        thread._done.set()
        thread.killRepl()
        # SESSIONS['guest'].sessionids.remove(sid)
        try:
            del SESSIONS[sid]
        except KeyError:
            pass
    else:
        SESSIONS[uname].sessionids.remove(sid)

@SOCKETIO.on('replstdin')
def handle_replstdin(line):
    find_session().readCommand(line)

@SOCKETIO.on('replkill')
def handle_replkill():
    find_session().stopEval()

@SOCKETIO.on('comment')
def handle_comment(comment):
    sid = request.sid
    LOGGER.info("client %s submitted a comment: '%s'" % (sid, comment))
    filename = join(CONFIG['comment_dir'], '%s_%s.txt' % (timestamp(), sid))
    with open(filename, 'w') as f:
        f.write(comment.encode('utf-8'))

# TODO put uploads in a separate user folder
# TODO allow uploads of other file types too, not just .dtr
# TODO detect whether uploaded file was .dtr and update menu
#      (need to avoid incorrectly :loading non-dtr files)
@SOCKETIO.on('upload')
def handle_upload(data):
    repl = find_session()
    LOGGER.info("client %s uploaded a file: '%s'" % (repl.sessionid, data['fileName']))
    # TODO some kind of check and/or put in separate uploads folder
    filename = join(repl.workdir, data['fileName'])
    with open(filename, 'w') as f:
        f.write(data['fileData'])
    LOGGER.info("saved user file '%s'" % filename)

@SOCKETIO.on('reqscript')
def handle_reqscript(data):
    # TODO autosave script before downloading maybe-old version?
    name = data['fileName']
    LOGGER.info("client %s requested script download (name: '%s')" % (request.sid, name))
    repl = find_session()
    path = join(repl.workdir, name)
    LOGGER.info("sending '%s' to client %s" % (path, request.sid))
    with open(path, 'r') as f:
        txt = f.read()
    SOCKETIO.emit('dlscript', {'scriptName': name, 'scriptText': txt})

@SOCKETIO.on('reqresult')
def handle_reqresult():
    sid = request.sid
    LOGGER.info("client %s requested result download" % sid)
    path = join(find_session().tmpdir, 'vars/result')
    LOGGER.info("sending '%s' to client %s" % (path, request.sid))
    with open(path, 'r') as f:
        txt = f.read()
    # TODO what about when the result is an image? have them save as for now i guess
    # TODO how to not log the entire result file?
    SOCKETIO.emit('dlresult', {'resultName': 'result', 'resultText': txt})


############
# shortcut #
############

def check_shortcut_version():
    LOGGER.info('checking output of "shortcut --version"')
    version_expected = u'ShortCut 0.9.2'
    proc = spawn('shortcut', ['--version'], encoding='utf-8', timeout=None)
    try:
        proc.expect(version_expected, timeout=10)
    except:
        msg = '"shortcut --version" failed. Check your PATH and version.'
        msg += ' It should be: ' + str(version_expected)
        LOGGER.error(msg)
        raise SystemExit(1)

check_shortcut_version()

class ShortCutThread(Thread):
    def __init__(self, sessionid, username):
        LOGGER.debug('init ShortCutThread')
        LOGGER.info('creating session %s' % sessionid)
        # self.delay = 0.01
        self.sessionids = set([sessionid])
        self.username  = username
        self.currenttab  = 'Home' # changes when user clicks tabs
        user_dir = join(CONFIG['users_dir'], self.username)
        if exists(user_dir):
            self.workdir = user_dir
            self.tmpdir  = join(self.workdir, 'tmpdir')
        else:
            self.tmpdir  = join(CONFIG['tmp_dir'], sessionid)
            self.workdir = join(self.tmpdir, 'data')
            makedirs(self.workdir)
        try:
            symlink(CONFIG['examples_dir'], join(self.workdir, 'examples')) # TODO rename data examples?
        except OSError as e:
            LOGGER.warning('Exception: %s' % e)
            pass # already exists
        self._done = Event()
        self.process = None
        super(ShortCutThread, self).__init__()

    def run(self):
        options = [ARROW, u'Bye for now!'] # , '.*']
        while not self._done.is_set():
            try:
                self.spawnRepl()
                while True:
                    index = self.process.expect(options)
                    out = self.process.before + self.process.after
                    out = interpret_clear_code(self.sessionids, out) # catches shortcut's "clear screen" command
                    self.emitText(out)
                    # self.emitText(self.process.before.lstrip())
                    # self.emitText(self.process.after)
                    self.enableInput()
                    if index == 1:
                        break # quit repl
                        # SOCKETIO.emit('replclear')
            except Exception as e:
                LOGGER.warning('Exception in %s (%s): %s' % (self, self.sessionids, e))
                continue


    # TODO currently this is the same as killing the interpreter... handle separately in shortcut?
    def stopEval(self):
        # LOGGER.info('session %s stopping %s evaluation' % (self.sessionid, self.process.pid))
        LOGGER.info('session %s stopping evaluation' % self.sessionids)
        # self.emitText(u'Resetting demo...\n')
        # sleep(1)
        self.killRepl()
        self.spawnRepl()
        self.readCommand('\n') # without this the new repl doesn't print anything

    def killRepl(self):
        # see https://stackoverflow.com/a/22582602
        global SESSIONS
        LOGGER.info('session %s killing interpreter' % self.sessionids)
        try:
            #pgid = getpgid(self.process.pid)
            #killpg(pgid, SIGKILL)
            #self.process.wait()
            self.process.kill(0)
            self.process.close(force=True)
        except:
            LOGGER.error('FAILED TO KILL REPL')
        finally:
            # print SESSIONS
            if self.username == 'guest':
                for sid in self.sessionids: # should only ever be one
                    try:
                        del SESSIONS[sid]
                    except KeyError:
                        pass
                rmtree(self.tmpdir, ignore_errors=True)
            # else:
                # print SESSIONS
                # del SESSIONS[self.username]

    def spawnRepl(self):
        if self.process is not None:
            self.killRepl()
        args = ['--secure', '--noprogress', '--interactive', '--tmpdir', self.tmpdir, '--workdir', self.workdir, '--shared', CONFIG['shared_dir']]
        # self.process = Popen(cmd, stdin=PIPE, stdout=PIPE, stderr=STDOUT, preexec_fn=setsid)
        self.process = spawn('shortcut', args, encoding='utf-8', echo=False, timeout=None)
        # LOGGER.info('session %s spawned interpreter %s' % (self.sessionid, self.process.pid))
        LOGGER.info('session %s spawned interpreter' % self.sessionids)


    # TODO emitText -> emitText? readCommand -> readCommand

    def emitText(self, text):
        # hack to show images in the repl
        # TODO show with list brackets?
        old = u'\[?plot image \'(.*?)\''
        new = r' <img src="/img\1" style="max-width: 400px;"></img> '
        text = re.sub(old, new, text, flags=re.DOTALL)

        if not '<img' in text:
            # rewrites tmpdir and workdir paths for simpler routes
            # see find_real_filename for the rationale + undoing it
            # print "text before: '%s'" % text
            text = re.sub(self.workdir, '/WORKDIR', text)
            text = re.sub(self.tmpdir , '/TMPDIR' , text)
            # print "text after: '%s'" % text

        for sid in self.sessionids:
            SOCKETIO.emit('replstdout', text, namespace='/', room=sid)

    def readCommand(self, line):
        try:
            line = line.strip()
            # self.process.stdin.write(line + '\n')
            self.process.sendline(line)

            # TODO emit script name here too like the repl? or remove in favor of repl itself?
            # self.emitText(ARROW + line + '\n') # TODO no need to emit the arrow if repl does already
            # TODO ideally, would print the last line queued up from the repl but not carriage return yet
            #      for that, do i need some kind of extra flush command?
            self.emitText(line + '\n') # TODO no need to emit the arrow if repl does already

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
                # sleep(2)
                # self.readCommand(line)
                # self.readCommand(':show\n')

    def disableInput(self):
        for sid in self.sessionids:
            SOCKETIO.emit('replbusy', namespace='/', room=sid)

    def enableInput(self):
        for sid in self.sessionids:
            SOCKETIO.emit('replready', namespace='/', room=sid)

    #def emitStdout(self):
        # TODO make this into a main interact() method?

###########
# twisted #
###########

# this is based on https://gist.github.com/ianschenck/977379a91154fe264897
# but I had trouble getting the reloader to work without zombie processes

RESOURCE = WSGIResource(REACTOR, REACTOR.getThreadPool(), FLASK)
SITE = Site(RESOURCE)
# TODO write a function to clean up all threads in SESSIONS on shutdown
# REACTOR.addSystemEventTrigger('before', 'shutdown', cleanup_sessions)
LOGGER.debug('creating main twisted reactor on port %s' % CONFIG['port'])
REACTOR.listenTCP(CONFIG['port'], SITE)
# TODO which signal handlers?
LOGGER.debug('running reactor')
REACTOR.run(installSignalHandlers=True)
