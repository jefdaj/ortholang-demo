{% macro run_example(lines2) %}
  {%- with lines=lines2 -%}
    {%- include "runexample.html" -%}
  {%- endwith -%}
{% endmacro %}

{%- macro load_example(name) -%}
  {%- with path= 'examples/' + name -%}
    {%- include "loadcode.html" -%}
  {%- endwith -%}
{%- endmacro -%}


Phylogenomic cuts are lists of candidate genes whose distribution suggests they
might be imprortant for a trait of interest. If you know some species whose
genomes or transcriptomes should contain your genes and some related ones that
shouldn't, you probably have enough info to make a cut! It will also help to list
some known genes that the search should pick up and some that it shouldn't.

Although the idea sounds simple, in practice making a cut involves lots of
"gut" decisions about which species to compare and how to compare them. You
will get very different candidate genes depending on parameters like
e-value cutoff, and you can usually reduce the search space from huge to
managable by applying common sense.

Cut script is a simple(ish) language for setting up your search, measuring how
well it performs, and tweaking it until you're confident enough in the results
to start cloning. It aims to be the easiest way to conduct searches too complex
for a website, but not so complex that you need to control every little detail
in a "real" language like Python or R. It also aims to describe everything you
did succinctly and reproducibly, in a format suitable for supplemental materials.
Everyone wins when your work is easy to update and build on!


## About this Server

The `shortcut` program is a command-line language interpreter, kind of like
`python` or `R` but for cut scripts. On your left is a hacky "terminal" I made
so you can try it from a web browser. You can do most of the same things in it
that you could if you [install ShortCut on your computer][1], except:

* Some terminal niceties like tab completion of variables + function names are missing
* Long-running scripts might be killed to keep the demo responsive for others

You can upload your own genomes and gene lists, save and restore scripts,
and download results using the buttons under the terminal.
Making an account is optional, but scripts saved as `guest` are public and others might edit them.
No email or signup form required! Just [click here][3] and make up a username + password.
If you want to be updated when a new version comes out, leave your email in the comment box.

This "server" is just a regular desktop computer; for anything
compute-intensive you probably want to install ShortCut on your own hardware instead.
You can also contact Jeff (comment box or email) to discuss running your search on the
[Berkeley high-performance computing][2] cluster or installing ShortCut at your
institution.


## How to use the docs

The fastest way to start is probably to skip back and forth between the examples and tutorial.
Read the tutorial and look for each new concept in the examples,
or play with the examples and read the tutorial as needed when they don't do what you expect.

Either way you'll find two types of interactive code blocks.
Complete cut scripts with `Load` buttons like this:

{{ load_example('load03.cut') }}

... and examples of commands you would type in the terminal.
The `Run` button just types them for you.
They can include loading scripts, but also anything else you might do live:
redefine variables, look at depdencies, etc.

{{ run_example([':load examples/load03.cut', ':depends sequences_of_interest',
'sample 10 genes_of_interest', ':show']) }}


## How to use the terminal

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


[1]: https://github.com/jefdaj/shortcut
[2]: https://research-it.berkeley.edu/services/high-performance-computing
[3]: /user
