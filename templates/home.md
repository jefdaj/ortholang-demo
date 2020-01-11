{% import "macros.jinja" as macros with context %}

<center>
<img id="logo" src="/static/ortholang.svg"></img>
<h3 id="tagline">OrthoLang: fast, reproducible<br/>ortholog search scripts</h3>
</center>

You should try it if you want to...

* Quickly do more than a couple BLAST searches and compare the hits
* Find optimal e-value cutoffs, genes and genomes to include/exclude, etc.
* Compare BLAST to newer alternatives like DIAMOND or MMSeqs
* Start from an existing script, or publish yours for others to start from

Try the demo on the right,
or paste this in a terminal to install on Mac or Linux:

<pre id="installscript">
curl http://shortcut.pmb.berkeley.edu/install | bash
</pre>

Simplified interfaces to these sequence search programs are included:

- [BLAST+][blast] with [Psiblast-EXB][psiblastexb]
- BLAST+ reciprocal best hits (custom algorithm)
- [DIAMOND][diamond]
- [HMMER][hmmer]
- [CRB-BLAST][crbblast]
- [Orthofinder][orthofinder]
- [SonicParanoid][sonicparanoid]
- [MMSeqs2][mmseqs]

<div style="float: right;">
  <img class="centeredimg" src="/static/server.png" style="width:150px;"></img>
</div>

# Using the website

This site is intended primarily as a demo. It's run from a standard desktop
computer and restarted frequently during development. For anything
compute-intensive you probably want to install OrthoLang on your own hardware
instead. The terminal on the right is similar to the standard command line
interface you will get if you do that, except:

* Terminal niceties like tab completion and progress bars are missing
* Uploading and downloading files is a little awkward
* Long-running scripts might be killed to keep the server responsive

Edit scripts written by other guest users on the `guest` tab,
or make an account to save your own privately.

<!--
Most searches can be done on a laptop, but it depends what you want to do and
how big your genomes are. You can also contact Jeff (use the comment box or
find my email [here][niyogilab]) about collaborating, running your search on
the [Berkeley high-performance compute cluster][hpc], or installing OrthoLang
at your institution.
-->

## Example Code

There are two types of interactive code blocks.
Complete scripts with `Load` buttons like this:

{{ macros.load_script(user, 'examples/scripts/mmseqs.ol') }}

... and examples of other commands you would type in the terminal.
The `Run` button just types them for you.
They can include loading scripts, but also anything else you might do live:
evaluate or redefine variables, list dependencies, get `:help`, etc.

{{ macros.run_example([':load examples/scripts/load03.ol', ':help', ':type sequences_of_interest', ':type gbk_to_faa_each', 'sample 10 genes_of_interest']) }}

## Terminal Controls

<img src="{{ url_for('static', filename='controls.png') }}" style="width: 80%;"></img>

1. Type commands in the command line and press enter or click `Run` to run them.
   While a command is running this will grey out and `Run` will change to `Kill`,
   which kills the script if you decide it was taking too long.

2. Load an existing script, either one of the examples or something you wrote earlier.
   You can also upload a script along with any files it requires.

3. Save/download stuff. `Download result` has the latest result you evaluated,
   and `Download script` has the last version of the script you saved.

4. Comment box. Tell Jeff if there's something broken, something you want to see or are confused about,
   or anything else.

That's about it! Either start the tutorial and skip to the examples if you get bored,
or start there and refer to the tutorial if you get confused.

<!-- There are also some pre-recorded demos. They tend to be for longer, more
complicated or compute-intensive things and involve using OrthoLang in its
native Linux terminal environment rather than on the website.

{{ macros.asciicast('test.cast') }}
-->

<!--
TODO:
- setting up an editing environment
- interpreter basics
- setting where files go

-->

[github]: https://github.com/jefdaj/ortholang
[hpc]: https://research-it.berkeley.edu/services/high-performance-computing
[user]: /user
[niyogilab]: http://niyogilab.berkeley.edu/lab-directory
[nix]: https://nixos.org/nix
[blast]: https://blast.ncbi.nlm.nih.gov/Blast.cgi?CMD=Web&PAGE_TYPE=BlastDocs&DOC_TYPE=Download
[diamond]: https://github.com/bbuchfink/diamond
[hmmer]: http://hmmer.org/
[crbblast]: https://github.com/cboursnell/crb-blast
[orthofinder]: https://github.com/davidemms/OrthoFinder
[sonicparanoid]: http://iwasakilab.bs.s.u-tokyo.ac.jp/sonicparanoid/
[mmseqs]: https://github.com/soedinglab/MMseqs2
[psiblastexb]: https://github.com/kyungtaekLIM/PSI-BLASTexB
