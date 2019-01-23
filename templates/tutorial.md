{% import "macros.jinja" as macros with context %}

The best way to use this tutorial is probably to
load each example and play around with it a bit as you go. That's the fastest
way to learn, and also the fastest way for me to get bug reports. Just type
them in the box on the lower left. Something short like "I did this and
expected this, but this happened instead" is fine. If the tutorial is
confusing, that counts as a bug too!



## How to use the terminal

<img src="{{ url_for('static', filename='controls.png') }}" style="width: 80%;"></img>

1. Type text commands in the command line and press enter or click `Run` to run them.
   While a command is running this will grey out and `Run` will change to `Kill`,
   which kills the script if you decide it was taking too long.

2. Load an existing script, either one of the examples or something you wrote earlier.
   You can also upload a script.
   _Note: you can't upload gene lists or fasta files yet, but I'm working on adding that.
    Comment if you want it done faster!_

3. Save/download stuff. `Download result` always has the latest result,
   but `Download script` only has the last version you saved.

4. Comment box. Tell me if there's something broken, something you want to see or are confused about, or whatever.

## How to use the examples

There are two types of interactive code blocks.
Complete cut scripts with `Load` buttons like this:

{{ macros.load_example('load03.rrr') }}

... and examples of commands you would type in the terminal.
The `Run` button just types them for you.
They can include loading scripts, but also anything else you might do live:
redefine variables, look at depdencies, etc.

{{ macros.run_example([':load examples/load03', 'sample 10 genes_of_interest', ':show']) }}

### Test of Asciinema demos

TODO: re-record the current demos more tersely and put them in the docs like this:

{{ macros.asciicast('test.cast.rrr') }}


### Result and Other Variables

Let's start at the beginning.
This is probably the simplest script you could write:

{{ macros.load_example('variables01.rrr') }}

If you downloaded Detourrr and ran `detourrr --script variables01.rrr`, it would print
`"hello world!"`. You can also `Load` it in the demo terminal and type `result`.

You don't have to run a whole script at once though.
You'll spend most of your time editing it in the interpreter,
defining and evaluating individual variables.
Here is a script with several of them.

{{ macros.load_example('variables02.rrr') }}

Detourrr keeps track of dependencies between variables, like this:

![]({{ url_for('static',filename='vars.svg') }})

You can evaluate one of them by typing its name.
Anything it depends on ("needs") will also get evaluated.
You can find what a given variable needs with the `:neededfor` command,
and what needs it with `:needs`.

`result` always holds the latest result.
If you type a plain expression like `4 * 4` without assigning it to a variable,
that becomes the new `result`.
You can also assign it yourself when the script is done to say what the final result should be.

So, if you type `result` or `var4` here the graph will stay the same and
Detourrr will print `-1.485`. Then if you type `var2`, the graph will change to:

![]({{ url_for('static',filename='var2.svg') }})

And it will print `"nothing depends on var2 so far"`.... which technically isn't quite true anymore.


### Math

Math is pretty simple. It works like you would expect, except that everything
is left-to-right rather than following order of operations.

A few examples:

{{ macros.load_example('math01.rrr') }}

You can enter numbers in decimal or scientific notation. There's only one type
of number instead of the several different ones like doubles and floats you
would find in a typical language. Parentheses also work the regular "mathy" way
to group things together; you'll see a little further down that function
application doesn't use them.

Notice that Detourrr might remove your parentheses automatically,
but only where it doesn't change the meaning.


### Sets

Besides regular math, you might want to do set operations. They also apply left
to right and can be grouped with parentheses. They're very useful for comparing
lists of genes and genomes. With these 3 you can describe the equivalent of any
Venn diagram:

<img src="{{ url_for('static',filename='venn-sets.png') }}" width="300">

The single-character operators `|`, `&`, and `~` each work on two lists.
`any` and `all` work on lists of lists of any length.

_Note: actual Venn diagrams coming soon._


### Types and Filetypes

<!-- TODO bug: brackets misplaced in :type of & -->

Before loading files and running BLAST, we need to detour and learn a couple
things about how Detourrr evaluates code. If you skip this, things will be
confusing later!

The first important thing to know is that Detourrr is a typed language. Types
are the standard technique for preventing a large and very annoying class of
bugs where the script crashes partway through because you accidentally swapped
two variables or misread how some function works.  The idea is that your
program should fail immediately if it's not going to work, because why waste
time? (Python is famously bad at this)

To catch errors the interpreter tags each thing (variable or expression) with a
type: "number", "string", "blast hit table", etc. You can ask Detourrr the type
of anything with the `:type` command. For example, `:type "my string"` is `str`
and `:type var4` (from the example above) is `num`.

Each function has a "type signature" that says what types it accepts, and when
you try to call it with the wrong one the interpreter will stop you. Here are
the type signatures of a couple functions we've already used:

    * : num num -> num
    & : X.list X.list -> X.list

The first means that `*` takes two numbers and returns another number.

The second means "`&` (set intersection) takes two lists of any type X and
returns another list of the same type". So it works with lists of numbers or
lists of strings or lists of genomes, but you can't accidentally mix them.

You can see the types of all variables in your current script at once by typing
just `:type`. For the last example, it should look like:

```python
var1.num = 1.5
var2.str = "nothing needs var2 so far"
var3.num = 2.0e-3 * var1
var4.num = var3 * 5 - var1
result.num = var4
```

The second important thing to know is that in Detourrr, every piece of code you
evaluate gets written to its own temporary file. That's the reason for the
weird dot notation above: types are equivalent to file extensions.
After evaluating `var4` you can look in the temporary directory and find a file
`vars/var4.num` with `-1.485` written in it. If you create a list of numbers
you'll get a `.num.list`. You can also make a `.num.list.list` and so on.
Look at the `:type`s of these:

{{ macros.load_example('types01.rrr') }}

This might seem like overkill at first, but becomes important for large-scale
bookkeeping. Imagine you have a few hundred thousand cryptically named
tempfiles. Your script chews through them for several days and finally returns
an empty list (`[]`). You want to be confident that there really are no hits,
instead of going back and poring over every command to make sure two files
didn't get mixed up somewhere! This happened to me probably 10 or 15 times before I added the type system.

### Loading and Working with Sequence Files

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

{{ macros.load_example('load01.rrr') }}

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

{{ macros.load_example('load02.rrr') }}

The first one should generally be preferred for clarity though,
unless you mean to load a list of files that might change.

`load_list` loads a list of literal strings,
so you can input your gene IDs or a list of genomes to search.
Then wrap it in `load_<whatever>_each` to actually load those files if needed:

{{ macros.load_example('load03.rrr') }}


Here are a bunch of random things loaded properly to play around with:

<!-- TODO example -->

Once you have some genomes or other FASTA files loaded you can extract a list of sequence IDs:

<!-- TODO example -->

You can also start with a list of sequence IDs and extract just those sequences to a new FASTA:

<!-- TODO example -->

Finally, you can convert between formats and concatenate things:

<!-- TODO example -->

### NCBI BLAST+

Detourrr provides the most common NCBI BLAST programs, which differ in their
subject and query types. See the Reference tab at the top for all the variants.

A couple examples:

_Note: Just ask if you want one of the more exotic ones added, like `rps-blast` or `delta-blast`._

_Note: `:help` for individual functions coming soon._

You can also download the standard NCBI databases. Try this:

{{ macros.load_example('blast02.rrr') }}

{{ macros.load_example('blast01.rrr') }}

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
reason, Detourrr also includes CRB-BLAST ([Aubry _et al._ 2014][4]). For each
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

{{ macros.load_example('crb.rrr') }}

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
seem reasonable. Obviously that's not very high-throughput though. Detourrr
can't assess whether the results make sense, but you can use it to tune the
search settings to pick up known positive control genes while excluding as many
others as possible. That's the topic of the next section.

If you have a large number of similar genes, like a bunch of membrane
transporters, you might also try a hybrid strategy:

1. pick a few random ones with the `sample` function
2. confirm those work on the NCBI site
3. do them all in Detourrr


### Permute, Repeat, Summarize (PRS)

Making a cut involves choices: which genomes to include, whether to trust their
gene annotations, which BLAST functions to use, which e-value cutoffs to apply
at each step... How can you be sure the parameters you picked are reasonable?
Detourrr implements a novel solution made possible by lazy evaluation and
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

{{ macros.load_example('prs02.rrr') }}

### Plotting

{{ macros.load_example('plot_histogram.rrr') }}

{{ macros.load_example('plot_scatterplot.rrr') }}

{{ macros.load_example('plot_linegraph.rrr') }}


### Break up your code

You can include code from one script inside another.
It's pretty simple:

{{ macros.load_example('include.rrr') }}

Use it to keep the current code clean while you try something new!
