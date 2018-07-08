{%- macro load_example(name) -%}
  {%- with path=name -%}
    {%- include "loadexample.html" -%}
  {%- endwith -%}
{%- endmacro -%}

The best way to use this tutorial is probably to
load each example and play around with it a bit as you go. That's the fastest
way to learn, and also the fastest way for me to get bug reports. Just type
them in the box on the lower left. Something short like "I did this and
expected this, but this happened instead" is fine. If the tutorial is
confusing, that counts as a bug too!


### Result and Other Variables

Let's start at the beginning.
This is probably the simplest script you could write:

{{ load_example('variables01.cut') }}

If you downloaded ShortCut and ran `shortcut --script variables01.cut`, it would print
`"hello world!"`.

You don't have to run a whole script at once though.
You'll spend most of your time editing it in the interpreter,
defining and evaluating individual variables.
Here is a script with several of them.

{{ load_example('variables02.cut') }}

ShortCut keeps track of dependencies between variables, like this:

![]({{ url_for('static',filename='vars.svg') }})

You can evaluate one of them by typing its name.
Anything it depends on will also get evaluated.
You can find what a given variable depends on with the `:depends` command,
and what depends on it with `:rdepends` ("reverse dependencies").

`result` always holds the latest result.
If you type a plain expression like `4 * 4` without assigning it to a variable,
that becomes the new `result`.
You can also assign it yourself when the script is done to say what the final result should be.

So, if you type `result` or `var4` here the graph will stay the same and
ShortCut will print `-1.485`. Then if you type `var2`, the graph will change to:

![]({{ url_for('static',filename='var2.svg') }})

... and it will print `"nothing depends on var2 so far"`.

### Math

Math is pretty simple. It works like you would expect, except that everything
is left-to-right rather than following order of operations. _Note: that could
be added easily if people prefer it._

A few examples:

{{ load_example('math01.cut') }}

You can enter numbers in decimal or scientific notation. There's only one type
of number instead of the several different ones like doubles and floats you
would find in a typical language. Parentheses also work the regular "mathy" way
to group things together; you'll see a little further down that function
application doesn't use them.

Notice that ShortCut might remove your parentheses automatically,
but only where it doesn't change the meaning.
<!-- TODO bug: it actually does seem to matter here. Put PEMDAS back? -->

### Sets

Besides regular math, you might want to do set operations. They also apply left
to right and can be grouped with parentheses. They're very useful for comparing
sets of genes and genomes. With these 3 you can describe the equivalent of any
Venn diagram:

<img src="https://github.com/jefdaj/ShortCut/raw/master/poster/venn-sets.png" width="300">

_Note: actual Venn diagrams coming soon._


### Types and Filetypes

<!-- TODO bug: brackets misplaced in :type of & -->

Before loading files and running BLAST, we need to detour and learn a couple
things about how ShortCut evaluates code. If you skip this, things will be
confusing later!

The first important thing to know is that ShortCut is a typed language. Types
are the standard technique for preventing a large and very annoying class of
bugs where the script crashes partway through because you accidentally swapped
two variables or misread how some function works.  The idea is that your
program should fail immediately if it's not going to work, because why waste
time? (Python is famously bad at this)

To catch errors the interpreter tags each thing (variable or expression) with a
type: "number", "string", "blast hit table", etc. You can ask ShortCut the type
of anything with the `:type` command. For example, `:type "my string"` is `str`
and `:type var4` (from the example above) is `num`.

Each function has a "type signature" that says what types it accepts, and when
you try to call it with the wrong one the interpreter will stop you. Here are
the type signatures of a couple functions we've already used:

    * : num num -> num
    & : <whatever>.list <whatever>.list -> <whatever>.list

The first means that `*` takes two numbers and returns another number.

The second one is my possibly-too-casual notation for "set intersection takes
two lists of any type and returns another list of the same type". So it works
with lists of numbers or lists of strings or lists of genomes, but you can't
accidentally mix them.

You can see the types of all variables in your current script at once by typing
just `:type`. For the last example, it should look like:

```python
var1.num = 1.5
var2.str = "nothing depends on var2 so far"
var3.num = 2.0e-3 * var1
var4.num = var3 * 5 - var1
result.num = var4
```

The second important thing to know is that in ShortCut, every piece of code you
evaluate gets written to its own temporary file. That's the reason for the
weird dot notation above: types are equivalent to file extensions.
After evaluating `var4` you can look in the temporary directory and find a file
`vars/var4.num` with `-1.485` written in it. If you create a list of numbers
you'll get a `.num.list`. You can also make a `.num.list.list` and so on.
Look at the `:type`s of these:

{{ load_example('types01.cut') }}

This might seem like overkill at first, but becomes important for large-scale
bookkeeping. Imagine you have a few hundred thousand cryptically named
tempfiles. Your script chews through them in various ways and finally returns
an empty list (`[]`). You want to be confident that there really are no hits,
instead of going back and poring over every command to make sure two files
didn't get mixed up somewhere! This happened to me probably 10 or 15 times before I added the type system.

### Loading and Working with Sequence Files

Test code block:

```python
import os
os.kill(everything)
```

OK, so how does that relate to loading sequences and running BLAST?
When you load a file you need to use the right type of load function.
Here are the current options:

    load_faa          : str      -> faa
    load_faa_each     : str.list -> faa.list
    load_faa_glob     : str      -> faa.list
    load_fna          : str      -> fna
    load_fna_each     : str.list -> fna.list
    load_fna_glob     : str      -> fna.list
    load_gbk          : str      -> gbk
    load_gbk_each     : str.list -> gbk.list
    load_gbk_glob     : str      -> gbk.list
    load_list         : str      -> str.list
    load_nucl_db      : str      -> ndb
    load_nucl_db_each : str.list -> ndb.list
    load_prot_db      : str      -> pdb
    load_prot_db_each : str.list -> pdb.list

The basic types they load are:

* `fna` and `faa` for FASTA nucleic acid and amino acid respectively
* `ndb` and `pdb` for BLAST nucleic acid and protein databases respectively
* `gbk` for Genbank

I often name my actual files with these extensions, but you don't have to.
`.fasta` or `.genes.masked.fa` or whatever a particular sequencing project named it
is fine as long as you use the right load function.

The `_each` versions take a list of strings and load a list of files.
There are also `concat_` functions for types that can be concatenated,
which is helpful if a genome is distributed as multiple files.

{{ load_example('load01.cut') }}

As you can see if you try it out, evaluating those functions prints the first few lines.
Lists do the same thing for each element.
For some types like BLAST databases that wouldn't work,
so you get a summary instead (see next section).

If you look at the `:type` of that script, hopefully the notation will start to seem reasonable!

Another thing to notice is that function application doesn't use parentheses;
it happens automatically when you put things next to each other and parentheses are
only needed for grouping when that would be unclear.
They can be omitted if something else breaks up the function calls,
like they're inside a list or on different lines.

The `_glob` versions are similar to the `_each` ones but take a single string with a "glob"
wildcard pattern describing the files to load.
These two do the same thing:

{{ load_example('load02.cut') }}

The first one should generally be preferred for clarity though,
unless you mean to load a list of files that might change.

`load_list` loads a list of literal strings,
so you can input your gene IDs or a list of genomes to search.
Then wrap it in `load_<whatever>_each` to actually load those files if needed:

{{ load_example('load03.cut') }}


Here are a bunch of random things loaded properly to play around with:

<!-- TODO example -->

Once you have some genomes or other FASTA files loaded you can extract a list of sequence IDs:

<!-- TODO example -->

You can also start with a list of sequence IDs and extract just those sequences to a new FASTA:

<!-- TODO example -->

Finally, you can convert between formats and concatenate things:

<!-- TODO example -->

### NCBI BLAST+

ShortCut provides the most common NCBI BLAST programs, which differ in their
subject and query types.

| Function  | Query | Subject |
| :-------  | :---- | :------ |
| blastn    | nucl  | nucl    |
| blastp    | prot  | prot    |
| blastx    | trans | prot    |
| tblastn   | prot  | nucl (translated) |
| tblastx   | nucl (translated) | nucl (translated) |
| megablast | nucl  | nucl    |

There are several variants of each one, named with suffixes:

| Format            | Meaning |
| :-----            | :------ |
| `function`          | "Regular" version (no suffix) automatically creates a database from the subject FASTA file before searching |
| `function_db`       | Uses a prebuilt BLAST database as the subject. Useful for searching the larger NCBI databases, such as nr or refseq_rna |
| `function_rbh`      | Does forward and reverse searches (query -> subject, subject -> query), and keeps only the reciprocal best hits (those where each gene is the other's top hit) |
| `function_each`     | BLASTs the query against a list of subjects and returns a list of hit tables |
| `function_db_each`  | Searches against a list of prebuilt databases |
| `function_rbh_each` | Reciprocal best hits against a list of FASTA files |

A couple examples:


Not all functions come in all variants, because some of them wouldn't make sense.

_Note: Just ask if you want one of the more exotic ones added, like `rps-blast` or `delta-blast`._

_Note: `:help` for individual functions coming soon._

You can also download the standard NCBI databases. Try this:

{{ load_example('blast02.cut') }}

{{ load_example('blast01.cut') }}

The SwissProt DB will take a minute or two to download,
and then you should see a summary like this:

    Database: Non-redundant UniProtKB/SwissProt sequences
    469,560 sequences; 177,002,184 total residues
    Longest sequence: 35,213 residues
    Volumes: /tmp/tmpdirs/57862f1e67784c01814382ead3d122df/cache/blastdbget/swissprot.00

You can use it in any function that takes a protein database (`.pdb`).

### CRB-BLAST

Reciprocal best hits are the most common method used to find orthologs, but
they can sometimes be overly conservative, missing true orthologs. For that
reason, ShortCut also includes CRB-BLAST ([Aubry _et al._ 2014][4]). For each
pair of genomes, it:

1. Does a standard reciprocal BLAST search
2. Plots e-value vs sequence length of the reciprocal best hits and fits
   a curve to it
3. Adds non-reciprocal hits whose e-values are at least as good

This is illustrated in the paper:

<img src="https://github.com/jefdaj/ShortCut/raw/master/poster/crb-blast.png" height="400">

According to the authors it significantly improves the accuracy of ortholog
assignment. Another useful feature is that it prevents having to pick e-value
cutoffs.

Example:

{{ load_example('crb.cut') }}

### PSI-BLAST

When making a cut you'll often want to do a sensitive search for distant
homologs, and PSI-BLAST (position-specific iterated blast) is usually the best
one for that. You do have to be a little careful though, because it's possible
for the search to be "poisoned": if the first BLASTP iteration picks up
unrelated proteins, and they have more hits in the database than your actual
protein of interest does, it will train itself to pick up more and more of the
wrong ones.

So if you only have one or a few genes to search for the best strategy is to
look through the results of each iteration on the NCBI site to make sure they
seem reasonable. Obviously that's not very high-throughput though. ShortCut
can't assess whether the results make sense, but you can use it to tune the
search settings to pick up known positive control genes while excluding as many
others as possible. That's the topic of the next section.

If you have a large number of similar genes, like a bunch of membrane
transporters, you might also try a hybrid strategy:

1. pick a few random ones with the `sample` function
2. confirm those work on the NCBI site
3. do them all in ShortCut


### Permute, Repeat, Summarize (PRS)

Making a cut involves choices: which genomes to include, whether to trust their
gene annotations, which BLAST functions to use, which e-value cutoffs to apply
at each step... How can you be sure the parameters you picked are reasonable?
ShortCut implements a novel solution made possible by lazy evaluation and
caching: duplicate parts of the program, re-run them starting from alternate
values, and see how the results change.

Suppose you have the original program in the box on the left, and want to know,
"What happens to `var6` if I change `var1`?"

<img src="https://github.com/jefdaj/ShortCut/raw/master/poster/prs.png" width="800">

`repeat_each` recalculates `var6` starting from 3 alternate versions of `var1`,
and reports a list of results.

Note that this is all "repeat"; the "permute" and "summarize" steps would be
separate functions to generate the list of `var1` permutations and aggregate
the final results in some way, perhaps filtering or plotting them. The overall
strategy is similar to ["split apply combine"][9] in R.

Here is a simpler and more practical example:

{{ load_example('prs02.cut') }}

### Plotting

{{ load_example('plot_histogram.cut') }}

{{ load_example('plot_scatterplot.cut') }}

{{ load_example('plot_linegraph.cut') }}