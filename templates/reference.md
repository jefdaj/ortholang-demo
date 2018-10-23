This page is for looking up the function you want and how to use it.
See the Tutorial first for a general idea of how to write ShortCut code,
or the CookBook for more advanced design patterns.

<!-- TODO should be able to get :help on a specific function in the repl too -->


## Types

These are the things ShortCut can work with so far.

| Type  | Meaning |
| :---- | :------ |
| `str` | string (freeform text for filenames etc.) |
| `num` | number, which can be in decimal or scientific notation |
| `fna` | FASTA nucleic acid file |
| `faa` | FASTA amino acid file |
| `ndb` | BLAST nucleic acid database file |
| `pdb` | BLAST protein database file (note: not a PDB structure file) |
| `bht` | BLAST hits table |
| `gbk` | Genbank file |

You can also have lists of anything, including other lists: `str.list`, `str.list.list` etc.

I often name my actual files with these extensions, but you don't have to.
`.fasta` or `.genes.masked.fa` or whatever a particular sequencing project named it
is fine as long as you use the right load function.


## Load Functions

These determine what type ShortCut thinks your file is and therefore which functions you can use it in.

The input strings in most of these should be filenames,
either absolute or relative to your working directory.
The only exception is you can use `*` wildcards in the `glob` functions.

| Function            | Input      | Output     |
| :------------------ | :--------- | :--------- |
| `load_faa`          | `str`      | `faa`      |
| `load_faa_each`     | `str.list` | `faa.list` |
| `load_faa_glob`     | `str`      | `faa.list` |
| `load_fna`          | `str`      | `fna`      |
| `load_fna_each`     | `str.list` | `fna.list` |
| `load_fna_glob`     | `str`      | `fna.list` |
| `load_gbk`          | `str`      | `gbk`      |
| `load_gbk_each`     | `str.list` | `gbk.list` |
| `load_gbk_glob`     | `str`      | `gbk.list` |
| `load_list`         | `str`      | `str.list` |
| `load_nucl_db`      | `str`      | `ndb`      |
| `load_nucl_db_each` | `str.list` | `ndb.list` |
| `load_prot_db`      | `str`      | `pdb`      |
| `load_prot_db_each` | `str.list` | `pdb.list` |

The `_each` versions take a list of strings and load a list of files.


## Convert Functions

These get things in the right format before/after working with them.

| Function            | Input      | Output     |
| :------------------ | :--------- | :--------- |
| `concat_fna`        | `fna.list` | `fna`      |
| `concat_faa`        | `faa.list` | `faa`      |
| `split_fna`         | `fna`      | `fna.list` |
| `split_faa`         | `faa`      | `faa.list` |
| `gbk_to_fna`        | `gbk`      | `fna`      |
| `gbk_to_faa`        | `gbk`      | `faa`      |
| `extract_queries`   | `bht`      | `str.list` |
| `extract_targets`   | `bht`      | `str.list` |


## Math and Set Operators

These all take two inputs and combine them into one output of the same type.
Math works as you expect, except no order of operations. Use parentheses as needed.

| Operator | Types | Meaning |
| :------- | :---- | :------ |
| `+`      | `num` | addition |
| `-`      | `num` | subtraction |
| `*`      | `num` | multiplication |
| `/`      | `num` | division |

Set operations are similar, except they require two lists of the same type.

| Operator | Types | Meaning |
| :------- | :---- | :------ |
| `|`      | `list` | set union |
| `&`      | `list` | set intersection |
| `~`      | `list` | set difference |

You can describe any complicated pattern of overlaps with a few of these and some parentheses.
The easiest way to think about them is as representing Venn diagrams.


## BLAST+

ShortCut provides most of the standard NCBI BLAST+ functions, which differ in their query and subject types:

| Function  | Query | Subject |
| :-------  | :---- | :------ |
| blastn    | nucl  | nucl    |
| blastp    | prot  | prot    |
| blastx    | trans | prot    |
| tblastn   | prot  | nucl (translated) |
| tblastx   | nucl (translated) | nucl (translated) |
| megablast | nucl  | nucl    |

They each return a BLAST hit table (`bht`). Use
`extract_queries` to get a list of genes from your query genome with hits, or
`extract_targets` for a list of the genes they matched. Use `length` to find
out how many hits without printing all of them.

There are several variants of each one, named with suffixes:

| Format            | Meaning |
| :-----            | :------ |
| `function`          | "Regular" version (no suffix) automatically creates a database from the subject FASTA file before searching |
| `function_db`       | Uses a prebuilt BLAST database as the subject. Useful for searching the larger NCBI databases, such as nr or refseq_rna |
| `function_rbh`      | Does forward and reverse searches (query -> subject, subject -> query), and keeps only the reciprocal best hits (those where each gene is the other's top hit) |
| `function_each`     | BLASTs the query against a list of subjects and returns a list of hit tables |
| `function_db_each`  | Searches against a list of prebuilt databases |
| `function_rbh_each` | Reciprocal best hits against a list of FASTA files |

Not all functions come in all variants, because some of them wouldn't make sense.
For example, `blastx_rbh` couldn't do the reverse searches while still being BLASTX.

## PsiBLAST

## HMMER

## InParanoid

## OrthoFinder

## SourMash

## TreeCl
