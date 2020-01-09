<div id="intropitch" style="width:80%;">
<img src="/static/ortholang.svg" style="width:250px;"></img>
<h2>OrthoLang: fast, reproducible<br/>ortholog search scripts</h2>
</div>

<!-- <div id="devwarning">
<b>WARNING: Demo under construction.
<br/>
You may need to zoom out to fix the layout.</b>
<br/>
</div>
<br/> -->

OrthoLang is a small scripting language designed to help you search for candidate genes.
Load some genes and genomes,
find homologs using a variety of programs,
and tweak + compare until you're confident in the results.
Save your final script to reproduce or update with new data later.

[Install it from Github][1] or try the demo terminal on the right.

Simplified interfaces to these sequence search programs are included so far:

- [BLAST+][5] with [Psiblast-EXB][12]
- BLAST+ reciprocal best hits (custom)
- [DIAMOND][6]
- [HMMER][7]
- [CRB-BLAST][8]
- [Orthofinder][9]
- [SonicParanoid][10]
- [MMSeqs2][11]

OrthoLang runs them more or less as you would on the command line, but automatically manages everything.
It caches intermediate files and shares them between programs when possible,
re-running only the commands that change with each variation of your search.
It can also plot how the results change given different genes or genomes, positive or negative control lists,
or search methods.

<!-- And if you need to customize the script beyond what OrthoLang can do,
combine it with other programs or manually inspect the output files.
_Your collaborators will still be grateful that you partially automated it!_ -->

<!--
Scripting makes it easier for you to compare search methods now,
and easier for others to build on your work later.
If you need to customize the script beyond what `ortholang` can do, combine it with something else:
call your code from `ortholang`, call `ortholang` from your code, or work with the output files manually.

## Quick Start

The fastest way to start is probably to skip back and forth between the Examples and Tutorial.
Read the tutorial and look for each new concept in the examples,
or play with the examples and read the tutorial as needed when they don't do what you expect.
-->

[1]: https://github.com/jefdaj/ortholang
[5]: https://blast.ncbi.nlm.nih.gov/Blast.cgi?CMD=Web&PAGE_TYPE=BlastDocs&DOC_TYPE=Download
[6]: https://github.com/bbuchfink/diamond
[7]: http://hmmer.org/
[8]: https://github.com/cboursnell/crb-blast
[9]: https://github.com/davidemms/OrthoFinder
[10]: http://iwasakilab.bs.s.u-tokyo.ac.jp/sonicparanoid/
[11]: https://github.com/soedinglab/MMseqs2
[12]: https://github.com/kyungtaekLIM/PSI-BLASTexB
