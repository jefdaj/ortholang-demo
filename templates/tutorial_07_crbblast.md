### CRB-BLAST

Reciprocal best hits are the most common method used to find orthologs, but
they can sometimes be overly conservative, missing true orthologs. For that
reason, OrthoLang also includes CRB-BLAST ([Aubry _et al._ 2014][1]). For each
pair of genomes, it:

1. Does a standard reciprocal BLAST search
2. Plots e-value vs sequence length of the reciprocal best hits and fits
   a curve to it
3. Adds non-reciprocal hits whose e-values are at least as good

This is illustrated in the paper:

<img src="{{ url_for('static',filename='crb-blast.png') }}" width="400">

According to the authors it significantly improves the accuracy of ortholog
assignment. Another useful feature is that it prevents having to pick e-value
cutoffs.

Example:

{{ macros.load_cut(user, 'examples/cut-scripts/crb.cut') }}

[1]: https://journals.plos.org/plosgenetics/article?id=10.1371/journal.pgen.1004365
