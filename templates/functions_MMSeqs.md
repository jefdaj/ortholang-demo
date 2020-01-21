### MMSeqs

Many-against-many sequence searching: ultra fast and sensitive search and clustering suite.

Types:

| Name      | Meaning |
| :-------- | :------ |
| <a href="javascript:;" onclick="help_and_scripts('faa')">`faa`</a> | FASTA (amino acid) |
| <a href="javascript:;" onclick="help_and_scripts('fna')">`fna`</a> | FASTA (nucleic acid) |
| <a href="javascript:;" onclick="help_and_scripts('bht')">`bht`</a> | tab-separated table of blast hits (outfmt 6) |
| <a href="javascript:;" onclick="help_and_scripts('mms')">`mms`</a> | MMSeqs2 sequence database |

Functions:

| Name | Type |
| :--- | :--- |
| <a href="javascript:;" onclick="help_and_scripts('mmseqs_createdb_all')">`mmseqs_createdb_all`</a> | ` fa.list -> mms` |
| <a href="javascript:;" onclick="help_and_scripts('mmseqs_createdb')">`mmseqs_createdb`</a> | ` fa -> mms` |
| <a href="javascript:;" onclick="help_and_scripts('mmseqs_search_db')">`mmseqs_search_db`</a> | ` num fa mms -> bht` |
| <a href="javascript:;" onclick="help_and_scripts('mmseqs_search')">`mmseqs_search`</a> | ` num fa fa -> bht` |

<br/>
{{ macros.load_script(user, 'examples/scripts/mmseqs.ol') }}
