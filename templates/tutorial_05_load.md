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

{{ macros.load_cut(user, 'examples/load01.cut') }}

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

{{ macros.load_cut(user, 'examples/load02.cut') }}

The first one should generally be preferred for clarity though,
unless you mean to load a list of files that might change.

`load_list` loads a list of literal strings,
so you can input your gene IDs or a list of genomes to search.
Then wrap it in `load_<whatever>_each` to actually load those files if needed:

{{ macros.load_cut(user, 'examples/load03.cut') }}


Here are a bunch of random things loaded properly to play around with:

<!-- TODO example -->

Once you have some genomes or other FASTA files loaded you can extract a list of sequence IDs:

<!-- TODO example -->

You can also start with a list of sequence IDs and extract just those sequences to a new FASTA:

<!-- TODO example -->

Finally, you can convert between formats and concatenate things:

<!-- TODO example -->
