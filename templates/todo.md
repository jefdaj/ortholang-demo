Tutorial:

* Include an explanation of the web interface

* Transcribe from github readme:

    - Sets
    - BLAST fn lists
    - CRB-BLAST section
    - GreenCut? Maybe but it needs work
    - PRS section

* Add test scripts to start from:

    - depends
    - fntypes into a reference at the end
    - glob
    - blast_db(_each)
    - compare blast fns (from multiple test files)
    - one crb_blast thing (then add another comparing results to regular blast?)
    - blastdblist
    - best_hits and reciprocal_best (use them to show repeat fn too)
    - extract_queries/targets
    - filter_evalue?
    - plot_histogram
    - plot_linegraph
    - plot_scatterplot
    - repeat_each, repeat_each_recursive
    - score_repeats
    - concat_hits
    - extract_seqs, extract_targets
    - split_fasta
    - translate
    - psiblast
    - psiblast_each, _all
    - psiblast_db (show making one and using an NCBI one)
    - psiblast_pssm
    - psiblast_pssms_db? (if used in greencut)
    - psiblast_train* (put near the beginning)
    - psiblast_train_pssms_db (if used in greencut)

* Add green-train from my committee meeting:

    - show how to start small with a few query pssms and scale up
    - if possible, compare a couple different training cutoffs
    - show variables when explaining types + extensions

* Add example of getting homolog IDs that I just used for greencut
* Actually make a section at the end for the current greencut
* Add example from Dhruv?
* Add a PSIICut if you can get it working! Probably not though
* Add johancut if you can get it working! maybe just with a smaller number of genes
* Add table of psiblast types from code to a reference eventually
* Go through all those test scripts and make them more useful/interesting for tutorial
* Reference section with all available functions? maybe later
* Example of error if you try to mix set types
* Table of contents
* Tmpfiles
* Types (genes, genomes, lists)
* BLAST+ (types, functions, difference between blastn and megablast)
* Psiblast (pssms, functions)
* PRS Pattern
* Permute (leave_each_out, sample)
* Repeat (repeat and randomness, repeat_each)
* Summarize (length_each, score_*, plot_*)

ShortCut demo features:

* get plain markdown working in templates
* refresh "load script" menu when new scripts written
* have shortcut also look for files in a default tmpdir if possible
* if not possible, mass symlink a default folder of tmpfiles to each new one on startup
* add "repl" code blocks that autorun each line as a command? if so, use different color blocks

ShortCut bugfixes:

* redefining result shouldn't cause things to be evaluated
* crash when running several blast searches at once
* repeat_each not evaluating the list elements in parallel

ShortCut features:

* anything more needed to turn trained pssms into a working greencut?
* generate homolog tables like for johan
* bar graphs for comparing different genomes, sets of genomes to use
* Venn diagrams if easy from that (don't waste time!)
* include statements should be fairly easy
* don't include the var itself in :rdepends output?