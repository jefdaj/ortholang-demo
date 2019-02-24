{% import "macros.jinja" as macros with context %}

The terminal on the right is similar to what you will get if you [install ShortCut][1], except:

* You have to upload and download your files one at a time
* Long-running scripts might be killed to keep the server responsive for others
* Some terminal niceties like tab completion of variables + function names are missing

<img src="/static/server.png" style="float:right; width:150px;"></img>

You can upload your own genomes and gene lists, save and restore scripts,
and download results using the buttons under the terminal.

Making an account is optional, but scripts saved as `guest` are public and others might edit them.
Also guest terminal sessions are destroyed when you leave the page, whereas named ones resume later.
No email or signup form is required to make an account! Just [click here][3] and make up a username + password to log in.
If you want to be updated when a new version comes out, leave your email in the comment box.

This "server" is an old desktop computer; for anything
compute-intensive you probably want to install ShortCut on your own hardware
instead! You can also contact Jeff (use the comment box or find my email
[here][4]) about collaborating, running your search on the [Berkeley
high-performance compute cluster][2], or installing ShortCut at your institution.

<!--
Here are some cut scripts. Press the `Load` button to load one in the terminal,
then type `result` to run it. You can also run intermediate variables or redefine them.
Try changing some numbers.
-->

Here are some example scripts. See the Tutorial and Reference tabs for details.

{{ macros.load_cut(user, 'examples/blast.cut') }}

{{ macros.load_cut(user, 'examples/prs02.cut') }}

Find reciprocal best PSI-BLAST hits between two genomes,
one of which comes as two files:

{{ macros.load_cut(user, 'examples/psiblast_rbh.cut') }}

Repeat any series of steps, changing one variable at a time and plotting the results.
(Trivial steps shown here)

{{ macros.load_cut(user, 'examples/plot_linegraph.cut') }}

_Note: these mostly use BLAST, but multiple sequence alignments +
tree building + clustering are in the works too._

[1]: https://github.com/jefdaj/shortcut
[2]: https://research-it.berkeley.edu/services/high-performance-computing
[3]: /user
[4]: http://niyogilab.berkeley.edu/lab-directory
