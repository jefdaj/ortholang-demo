{% import "macros.jinja" as macros with context %}

Here are some cut scripts. Press the `Load` button to load one in the terminal,
then type `result` to run it. You can also run intermediate variables or redefine them.
Try changing some numbers.

{{ macros.load_example('blast.dtr') }}

{{ macros.load_example('prs02.dtr') }}

Find reciprocal best PSI-BLAST hits between two genomes,
one of which comes as two files:

{{ macros.load_example('psiblast_rbh.dtr') }}

Repeat any series of steps, changing one variable at a time and plotting the results.
(Trivial steps shown here)

{{ macros.load_example('plot_linegraph.dtr') }}

_Note: these mostly use BLAST, but multiple sequence alignments +
tree building + clustering are in the works too._
