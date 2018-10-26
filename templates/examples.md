{%- macro load_example(name) -%}
  {%- with path='examples/' + name -%}
    {%- include "loadcode.html" -%}
  {%- endwith -%}
{%- endmacro -%}

Here are some cut scripts. Press the `Load` button to load one in the terminal,
then type `result` to run it. You can also run intermediate variables or redefine them.
Try changing some numbers.

{{ load_example('prs02.cut') }}

Find reciprocal best PSI-BLAST hits between two genomes:

{{ load_example('psiblast_rbh.cut') }}

Repeat any series of steps, changing one variable at a time and plotting the results.
(Trivial steps shown here)

{{ load_example('plot_linegraph.cut') }}

_Note: these mostly use BLAST, but multiple sequence alignments +
tree building + clustering are in the works too._
