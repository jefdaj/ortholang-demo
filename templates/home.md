<div id="intropitch">
<img src="/static/detourrr.png" style="width:200px;"></img>
<br/>
<br/>
<!-- There's more than one way to get there.<br/> -->
<!-- Compare and combine sequence searches.<br/> -->
<!-- Try more than one workflow.<br/> -->
<!-- Combine and compare sequence searches.<br/> -->
Combine and compare workflows.<br/>
Find a <b>R</b>apid, <b>R</b>obust, <b>R</b>eproducible<br/>
route to your candidate genes!
</div>

<!--
## What is it?
-->

Detourrr is a small scripting language designed to help you search for candidate genes.
Load some genes and genomes,
find homologs using a variety of programs,
and tweak + compare until you're confident in the results.
Save your final script to reproduce or update with new data later.

Simplified interfaces to these sequence search programs are included so far:

- [BLAST+][5]
- BLAST+ reciprocal best hits (custom)
- [DIAMOND][6]
- [HMMER][7]
- [CRB-BLAST][8]
- [Orthofinder][9]
- [SonicParanoid][10]
- [MMSeqs2][11]

Detourrr runs them more or less as you would on the command line, but automatically manages everything.
It caches intermediate files and shares them between programs when possible,
re-running only the commands that change with each variation of your search.
It can also plot how the results change given different genes or genomes, positive or negative control lists,
or search methods.

<!-- And if you need to customize the script beyond what Detourrr can do,
combine it with other programs or manually inspect the output files.
_Your collaborators will still be grateful that you partially automated it!_ -->

<!--
Scripting makes it easier for you to compare search methods now,
and easier for others to build on your work later.
If you need to customize the script beyond what `detourrr` can do, combine it with something else:
call your code from `detourrr`, call `detourrr` from your code, or work with the output files manually.

## Quick Start

The fastest way to start is probably to skip back and forth between the Examples and Tutorial.
Read the tutorial and look for each new concept in the examples,
or play with the examples and read the tutorial as needed when they don't do what you expect.
-->

[1]: https://github.com/jefdaj/shortcut
[5]: https://blast.ncbi.nlm.nih.gov/Blast.cgi?CMD=Web&PAGE_TYPE=BlastDocs&DOC_TYPE=Download
[6]: https://github.com/bbuchfink/diamond
[7]: http://hmmer.org/
[8]: https://github.com/cboursnell/crb-blast
[9]: https://github.com/davidemms/OrthoFinder
[10]: http://iwasakilab.bs.s.u-tokyo.ac.jp/sonicparanoid/
[11]: https://github.com/soedinglab/MMseqs2
