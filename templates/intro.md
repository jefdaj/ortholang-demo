{% macro run_example(lines2) %}
  {%- with lines=lines2 -%}
    {%- include "runexample.html" -%}
  {%- endwith -%}
{% endmacro %}

{%- macro load_example(name) -%}
  {%- with path=name -%}
    {%- include "loadexample.html" -%}
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

The `shortcut` program is a command-line language interpreter, kind of like
`python` or `R` but for cut scripts. On your left is a hacky "terminal" I made
so it can be run from a web browser. You can do most of the same things in it
that you could if you downloaded ShortCut proper, except:

* Your session will be deleted when you leave this page
* The server might kill your script without warning if it takes too much CPU time
* Some terminal niceties like tab completion and clearing the screen are missing

You can upload your own genomes and gene lists, save and restore scripts,
and download results using the buttons at the bottom left.

## How to use the terminal

The terminal on the left interacts with a ShortCut interpreter running on the server.
It gets wiped and replaced with a new one if you leave or refresh the page.
Here are the controls:

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

The righthand side is documentation. It includes lots of code samples.  There are two types of interactive code blocks:

Complete cut scripts with `Load` buttons to load them in the interpreter. For example:

{{ load_example('load03.cut') }}

Examples of commands you would type in the interpreter.
The `Run` button just types them for you.
They can include loading scripts, but also anything else you might do live:
redefine variables, look at depdencies, etc. For example:

{{ run_example([':load green.cut', ':depends green_hits', ':rdepends green_hits']) }}

The best way to approach the tutorial is to guess what each command will do, try it, and then rethink if the output was unexpected.
That will get you going much faster than just reading and thinking "Sure that makes sense".
