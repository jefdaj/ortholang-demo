<div id="intropitch">
<img src="/static/detourrr.png" style="width:200px;"></img>
<br/>
<br/>
<!-- There's more than one way to get there.<br/> -->
Compare and combine sequence searches.<br/>
Find a <b>R</b>apid, <b>R</b>obust, <b>R</b>eproducible<br/>
route to your candidate genes!
</div>

## What is it?

Detourrr is a small scripting language designed to help you search for candidate genes.
Load some genes and genomes,
find homologs using a variety of programs,
and tweak + compare until you're confident in the results.
Save your final script to reproduce or update with new data later.

Simplified interfaces to these search programs are included so far:

- [BLAST+][5]
- BLAST+ reciprocal best hits (custom)
- [DIAMOND][6]
- [HMMER][7]
- [CRB-BLAST][8]
- [Orthofinder][9]
- [SonicParanoid][10]
- [MMSeqs2][11]

Each one comes with a few basic functions to get you going with minimum fuss.
See the Examples tab for an idea of what the code looks like,
or the Reference tab for a complete list of functions in each module.

Detourrr runs them more or less as you would on the command line, but automatically manages everything.
It caches intermediate files and shares them between programs when possible,
re-running only the commands that change with each variation of your search.
It can also plot how the results change given different genes or genomes, positive or negative control lists, or search methods.

Scripting makes it easier for you to compare search methods now,
and easier for others to build on your work later.
If you need to customize the script beyond what `detourrr` can do, combine it with something else:
call your code from `detourrr`, call `detourrr` from your code, or work with the output files manually.
_Your collaborators will still be grateful if you partially automated it!_

## Quick Start

The fastest way to start is probably to skip back and forth between the Examples and Tutorial.
Read the tutorial and look for each new concept in the examples,
or play with the examples and read the tutorial as needed when they don't do what you expect.

## Demo

The demo terminal on the right is similar to what you will get if you [install Detourrr on your computer][1], except:

* You have to upload and download your files one at a time
* Long-running scripts might be killed to keep the server responsive for others
* Some terminal niceties like tab completion of variables + function names are missing

You can upload your own genomes and gene lists, save and restore scripts,
and download results using the buttons under the terminal.

<img src="/static/server.png" style="float:right; width:150px;"></img>

Making an account is optional, but scripts saved as `guest` are public and others might edit them.
Also guest terminal sessions are destroyed when you leave the page, whereas named ones resume later.
No email or signup form is required to make an account! Just [click here][3] and make up a username + password.
If you want to be updated when a new version comes out, leave your email in the comment box.

This "server" is just an old desktop computer I salvaged; for anything
compute-intensive you may want to install Detourrr on your own hardware
instead! You can also contact Jeff (use the comment box or find my email
[here][4]) about collaborating, running your search on the [Berkeley
high-performance compute cluster][2], or installing Detourrr at your institution.

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
