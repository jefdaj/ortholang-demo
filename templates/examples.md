{% import "macros.jinja" as macros with context %}

Here are some cut scripts. Press the `Load` button to load one in the terminal,
then type `result` to run it. You can also run intermediate variables or redefine them.
Try changing some numbers.

{{ macros.load_rrr(user, 'examples/blast.rrr') }}

{{ macros.load_rrr(user, 'examples/prs02.rrr') }}

Find reciprocal best PSI-BLAST hits between two genomes,
one of which comes as two files:

{{ macros.load_rrr(user, 'examples/psiblast_rbh.rrr') }}

Repeat any series of steps, changing one variable at a time and plotting the results.
(Trivial steps shown here)

{{ macros.load_rrr(user, 'examples/plot_linegraph.rrr') }}

_Note: these mostly use BLAST, but multiple sequence alignments +
tree building + clustering are in the works too._
