{%- macro load_example(name) -%}
  {%- with path='examples/' + name -%}
    {%- include "loadcode.html" -%}
  {%- endwith -%}
{%- endmacro -%}

OK, so what can you do with it? These examples are explained in more detail in
the tutorial below, but let's try running them first. Press one of the `Load`
buttons to fill in the command to load that example. Once it's loaded type
`:show` to show the variable definitions, then `result` to run everything.

{{ load_example('prs02.cut') }}

Find reciprocal best PSI-BLAST hits between two genomes:

{{ load_example('psiblast_rbh.cut') }}

Repeat any series of steps, changing one variable at a time and plotting the results.
(Trivial steps shown here)

{{ load_example('plot_linegraph.cut') }}

_Note: these mostly use BLAST, but multiple sequence alignments +
tree building + clustering are in the works too._
