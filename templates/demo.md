{% import "macros.jinja" as macros with context %}

The demo on the right is similar to the command line interface you will get if you [install ShortCut][1], except:

* You have to upload and download your files one at a time
* Long-running scripts might be killed to keep the server responsive for others
* Some terminal niceties like tab completion of variables + function names are missing

You can upload your own genomes and gene lists, save and restore scripts,
and download results using the buttons under the terminal.

<img src="/static/server.png" style="float:right; width:150px;"></img>

Making an account is optional, but scripts saved as `guest` are public and others might edit them.
Also guest terminal sessions are destroyed when you leave the page, whereas named ones resume later.
No email or signup form is required to make an account! Just [click here][3] and make up a username + password to log in.
If you want to be updated when a new version comes out, leave your email in the comment box.

This "server" is an old desktop computer; for anything
compute-intensive you probably want to install ShortCut on your own hardware
instead! You can also contact Jeff (use the comment box or find my email
[here][4]) about collaborating, running your search on the [Berkeley
high-performance compute cluster][2], or installing ShortCut at your institution.

## How to use the demo

<img src="{{ url_for('static', filename='controls.png') }}" style="width: 80%;"></img>

1. Type text commands in the command line and press enter or click `Run` to run them.
   While a command is running this will grey out and `Run` will change to `Kill`,
   which kills the script if you decide it was taking too long.

2. Load an existing script, either one of the examples or something you wrote earlier.
   You can also upload a script.
   _Note: you can't upload gene lists or fasta files yet, but I'm working on adding that.
    Comment if you want it done faster!_

3. Save/download stuff. `Download result` always has the latest result,
   but `Download script` only has the last version you saved.

4. Comment box. Tell me if there's something broken, something you want to see or are confused about, or whatever.

## How to use the examples

There are two types of interactive code blocks.
Complete cut scripts with `Load` buttons like this:

{{ macros.load_cut(user, 'examples/load03.cut') }}

... and examples of commands you would type in the terminal.
The `Run` button just types them for you.
They can include loading scripts, but also anything else you might do live:
redefine variables, look at depdencies, etc.

{{ macros.run_example([':load examples/load03', 'sample 10 genes_of_interest', ':show']) }}

### Test of Asciinema demos

TODO: re-record the current demos more tersely and put them in the docs like this:

{{ macros.asciicast('test.cast.cut') }}


[1]: https://github.com/jefdaj/shortcut
[2]: https://research-it.berkeley.edu/services/high-performance-computing
[3]: /user
[4]: http://niyogilab.berkeley.edu/lab-directory
