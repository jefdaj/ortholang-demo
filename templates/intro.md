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


<!--
<div id="account">account: {{ user }}
{% if user == 'guest' %}
<a id="loginlink" href="/user">Click here</a> to log in.
{% endif %}
</div>
-->

<div id="intropitch">
<img src="/static/detourrr.png" style="width:200px;"></img>
<br/>
<br/>
<!-- The <b>r</b>apid, <b>r</b>obust, <b>r</b>eproducible route to your candidate genes! -->
Spend a few minutes up front<br/>
to find a <b>r</b>apid, <b>r</b>obust, <b>r</b>eproducible<br/>
route to your candidate genes!
</div>

<!--
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
-->

Detourrr is a small scripting language for automating your search.
Load your genes and genomes,
find homologs using a variety of programs,
and tweak until you're confident in the results.
Save your final script to reproduce or update with new data later.
Simplified interfaces to these programs are included so far:

- [BLAST+][5]
- BLAST+ reciprocal best hits
- [DIAMOND][6]
- [HMMER][7]
- [CRB-BLAST][8]
- [Orthofinder][9]
- [SonicParanoid][10]
- [MMSeqs2][11]


Detourrr runs them more or less as you would on the command line, but automatically manages everything.
It caches intermediate files and shares them between programs when possible,
re-running only the commands that change with each variation of your search.
It can also plot how the results change given different genes or genomes, positive or negative control lists, or search methods.

Scripting makes it easier for you to compare search methods now,
and easier for others to build on your work later.
If you need to customize the script beyond what `detourrr` does, combine it with something else:
call your code from `detourrr`, call `detourrr` from your code, or work with the output files manually.
_Your collaborators will still be grateful if you partially automated it!_

## Demo

<!-- ![](/static/server.png) -->

The demo terminal on the right is similar to what you will get if you [install Detourrr on your computer][1], except:

* You can't use your own files without uploading and downloading them one at a time
* Some terminal niceties like tab completion of variables + function names are missing
* Long-running scripts might be killed to keep the server responsive for others

You can upload your own genomes and gene lists, save and restore scripts,
and download results using the buttons under the terminal.
Making an account is optional, but scripts saved as `guest` are public and others might edit them.
Also guest terminal sessions are destroyed when you leave the page, whereas named ones resume later.
No email or signup form is required to make an account! Just [click here][3] and make up a username + password.
If you want to be updated when a new version comes out, leave your email in the comment box.

This "server" is just a regular desktop computer; for anything
compute-intensive you may want to install Detourrr on your own hardware
instead. You can also contact Jeff (use the comment box or find my email
[here][4]) about collaborating, running your search on the [Berkeley
high-performance compute cluster][2], or installing Detourrr at your institution.


## How to use the docs

The fastest way to start is probably to skip back and forth between the examples and tutorial.
Read the tutorial and look for each new concept in the examples,
or play with the examples and read the tutorial as needed when they don't do what you expect.

Either way you'll find two types of interactive code blocks.
Complete cut scripts with `Load` buttons like this:

{{ load_example('load03.dtr') }}

... and examples of commands you would type in the terminal.
The `Run` button just types them for you.
They can include loading scripts, but also anything else you might do live:
redefine variables, look at depdencies, etc.

{{ run_example([':load examples/load03.dtr', 'sample 10 genes_of_interest', ':show']) }}


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
[4]: http://niyogilab.berkeley.edu/lab-directory
[5]: https://blast.ncbi.nlm.nih.gov/Blast.cgi?CMD=Web&PAGE_TYPE=BlastDocs&DOC_TYPE=Download
[6]: https://github.com/bbuchfink/diamond
[7]: http://hmmer.org/
[8]: https://github.com/cboursnell/crb-blast
[9]: https://github.com/davidemms/OrthoFinder
[10]: http://iwasakilab.bs.s.u-tokyo.ac.jp/sonicparanoid/
[11]: https://github.com/soedinglab/MMseqs2
