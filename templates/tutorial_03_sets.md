### Sets

Besides regular math, you might want to do set operations. They also apply left
to right and can be grouped with parentheses. They're very useful for comparing
lists of genes and genomes. With these you can describe the equivalent of any
Venn diagram:

<img src="{{ url_for('static',filename='venn-sets.png') }}" width="300">

The single-character operators `|`, `&`, and `~` each work on two lists.
`any` and `all` work on lists of lists of any length.

{{ macros.load_cut(user, 'examples/cut-scripts/sets.cut') }}

_Note: actual Venn diagrams coming soon._
