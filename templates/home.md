<center>
<img id="logo" src="/static/ortholang.svg"></img>
<h3 id="tagline">OrthoLang: fast, reproducible<br/>ortholog search scripts</h3>
</center>

Try the demo on the right,
or paste this in a terminal to install on Mac or Linux:

<pre style="font-size: 11pt;">
curl https://github.com/jefdaj/shortcut/blob/master/install.sh | bash
</pre>

Simplified interfaces to these sequence search programs are included:

- [BLAST+][5] with [Psiblast-EXB][12]
- BLAST+ reciprocal best hits (custom algorithm)
- [DIAMOND][6]
- [HMMER][7]
- [CRB-BLAST][8]
- [Orthofinder][9]
- [SonicParanoid][10]
- [MMSeqs2][11]

You should try it if you want to...

* Quickly do more than a couple BLAST searches and compare the hits
* Compare BLAST to newer alternatives like DIAMOND or MMSeqs
* Re-run your search later on new data, or publish it
* Find optimal e-value cutoffs, genes and genomes to include/exclude, etc.

[1]: https://github.com/jefdaj/ortholang
[5]: https://blast.ncbi.nlm.nih.gov/Blast.cgi?CMD=Web&PAGE_TYPE=BlastDocs&DOC_TYPE=Download
[6]: https://github.com/bbuchfink/diamond
[7]: http://hmmer.org/
[8]: https://github.com/cboursnell/crb-blast
[9]: https://github.com/davidemms/OrthoFinder
[10]: http://iwasakilab.bs.s.u-tokyo.ac.jp/sonicparanoid/
[11]: https://github.com/soedinglab/MMseqs2
[12]: https://github.com/kyungtaekLIM/PSI-BLASTexB
