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
might be imprortant for a trait of interest.

Cut script is a simple(ish) language for making phylogenomic cuts. It aims to
be the easiest way to conduct searches too complex for the NCBI website, but
not so complex that you want to get bogged down with all the details of a
"real" language like Python or R just to do some BLAST searches. It also aims
to describe searches succinctly and reproducibly, so that some day it might
make it into your supplemental material. Everyone wins when your work is easy
to build on!

## About this Server

The `shortcut` program is a command-line language interpreter, kind of like
`python` or `R` but for cut scripts. On your left is a hacky "terminal" I made
so you can try it from a web browser. You can do most of the same things in it
that you could if you [install ShortCut on your computer][1], except:

* Long-running scripts might be killed without warning to keep the demo responsive for others
* Some terminal niceties like tab completion and clearing the screen are missing

You can upload your own genomes and gene lists, save and restore scripts,
and download results using the buttons under the terminal.

For anything compute-intensive, you probably want to install it on your own computer
instead. You can also contact Jeff (bottom left) to discuss running your search
on the [Berkeley high-performance computing][2] cluster or installing ShortCut
at your institution.

## Make an account

This is optional, but scripts saved as `guest` are public and others might edit them.
No email or signup form required! Just [click here][3] and make up a username + password.
If you want to be updated when a new version comes out, leave your email in the comment box.

## How to use the terminal

<img src="{{ url_for('static', filename='controls.png') }}" style="width: 80%;"></img>

1. Type text commands in the command line and press enter or click `Run` to run them.
   While a command is running this will grey out and `Run` will change to `Kill`,
   which kills the script if you decide it was taking too long.

2. Load an existing script, either one of the examples or something you wrote earlier.
   You can also upload a script.
   _Note: you can't upload gene lists or fasta files yet, but I'm working on adding that.
    Comment if you want it done faster!_

3. Save/download stuff. The only rule here is please don't overwrite someone else's script!
   Pick your own unique name.
   `Download result` always has the latest result,
   but `Download script` only has the last version you saved.

4. Tell me if there's something broken, something you want to see or are confused about, or whatever.
   The site doesn't do any kind of user tracking, so include your name and the error message if applicable.

## How to use the docs

There are two types of interactive code blocks.
Complete cut scripts with `Load` buttons like this:

{{ load_example('load03.cut') }}

... and examples of commands you would type in the interpreter.
The `Run` button just types them for you.
They can include loading scripts, but also anything else you might do live:
redefine variables, look at depdencies, etc.

{{ run_example([':load green.cut', ':depends green_hits', ':rdepends green_hits']) }}


[1]: https://github.com/jefdaj/shortcut
[2]: https://research-it.berkeley.edu/services/high-performance-computing
[3]: /user
