### Permute, Repeat, Summarize (PRS)

Making a cut involves choices: which genomes to include, whether to trust their
gene annotations, which BLAST functions to use, which e-value cutoffs to apply
at each step... How can you be sure the parameters you picked are reasonable?
ShortCut implements a novel solution made possible by lazy evaluation and
caching: duplicate parts of the program, re-run them starting from alternate
values, and see how the results change.

Suppose you have the original program in the box on the left, and want to know,
"What happens to `var6` if I change `var1`?"

Using the `repeat_each` function you can recalculate `var6` starting from 3 alternate versions of `var1`:

<img src="{{ url_for('static',filename='prs.png') }}" width="800">

Note that this is all "repeat"; the "permute" and "summarize" steps would be
separate functions to generate the list of `var1` permutations (during step 2) and aggregate
the final results in some way, perhaps filtering or plotting them (during step 4).

Here is a more practical example that repeats a BLAST search with a list of cutoffs:

{{ macros.load_cut(user, 'examples/scripts/prs02.cut') }}
