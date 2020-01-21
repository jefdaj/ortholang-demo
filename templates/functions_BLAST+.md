### BLAST+

Standard NCBI BLAST+ functions.

Types:

| Type      | Meaning |
| :-------- | :------ |
| <a href="javascript:;" onclick="help_and_scripts('ndb')">`ndb`</a> | BLAST nucleotide database |
| <a href="javascript:;" onclick="help_and_scripts('pdb')">`pdb`</a> | BLAST protein database |
| <a href="javascript:;" onclick="help_and_scripts('bht')">`bht`</a> | tab-separated table of blast hits (outfmt 6) |

Functions:

| Name | Type |
| :--- | :--- |
| <a href="javascript:;" onclick="help_and_scripts('blastn')">`blastn`</a> | ` num fna fna -> bht` |
| <a href="javascript:;" onclick="help_and_scripts('megablast')">`megablast`</a> | ` num fna fna -> bht` |
| <a href="javascript:;" onclick="help_and_scripts('blastp')">`blastp`</a> | ` num faa faa -> bht` |
| <a href="javascript:;" onclick="help_and_scripts('blastx')">`blastx`</a> | ` num fna faa -> bht` |
| <a href="javascript:;" onclick="help_and_scripts('tblastn')">`tblastn`</a> | ` num faa fna -> bht` |
| <a href="javascript:;" onclick="help_and_scripts('tblastx')">`tblastx`</a> | ` num fna fna -> bht` |
| <a href="javascript:;" onclick="help_and_scripts('blastn_each')">`blastn_each`</a> | ` num fna fna.list -> bht.list` |
| <a href="javascript:;" onclick="help_and_scripts('megablast_each')">`megablast_each`</a> | ` num fna fna.list -> bht.list` |
| <a href="javascript:;" onclick="help_and_scripts('blastp_each')">`blastp_each`</a> | ` num faa faa.list -> bht.list` |
| <a href="javascript:;" onclick="help_and_scripts('blastx_each')">`blastx_each`</a> | ` num fna faa.list -> bht.list` |
| <a href="javascript:;" onclick="help_and_scripts('tblastn_each')">`tblastn_each`</a> | ` num faa fna.list -> bht.list` |
| <a href="javascript:;" onclick="help_and_scripts('tblastx_each')">`tblastx_each`</a> | ` num fna fna.list -> bht.list` |
| <a href="javascript:;" onclick="help_and_scripts('blastn_db')">`blastn_db`</a> | ` num fna ndb -> bht` |
| <a href="javascript:;" onclick="help_and_scripts('megablast_db')">`megablast_db`</a> | ` num fna ndb -> bht` |
| <a href="javascript:;" onclick="help_and_scripts('blastp_db')">`blastp_db`</a> | ` num faa pdb -> bht` |
| <a href="javascript:;" onclick="help_and_scripts('blastx_db')">`blastx_db`</a> | ` num fna pdb -> bht` |
| <a href="javascript:;" onclick="help_and_scripts('tblastn_db')">`tblastn_db`</a> | ` num faa ndb -> bht` |
| <a href="javascript:;" onclick="help_and_scripts('tblastx_db')">`tblastx_db`</a> | ` num fna ndb -> bht` |
| <a href="javascript:;" onclick="help_and_scripts('blastn_db_each')">`blastn_db_each`</a> | ` num fna ndb.list -> bht.list` |
| <a href="javascript:;" onclick="help_and_scripts('megablast_db_each')">`megablast_db_each`</a> | ` num fna ndb.list -> bht.list` |
| <a href="javascript:;" onclick="help_and_scripts('blastp_db_each')">`blastp_db_each`</a> | ` num faa pdb.list -> bht.list` |
| <a href="javascript:;" onclick="help_and_scripts('blastx_db_each')">`blastx_db_each`</a> | ` num fna pdb.list -> bht.list` |
| <a href="javascript:;" onclick="help_and_scripts('tblastn_db_each')">`tblastn_db_each`</a> | ` num faa ndb.list -> bht.list` |
| <a href="javascript:;" onclick="help_and_scripts('tblastx_db_each')">`tblastx_db_each`</a> | ` num fna ndb.list -> bht.list` |
| <a href="javascript:;" onclick="help_and_scripts('concat_bht')">`concat_bht`</a> | ` bht.list -> bht` |
| <a href="javascript:;" onclick="help_and_scripts('concat_bht_each')">`concat_bht_each`</a> | ` bht.list.list -> bht.list` |

<br/>
{{ macros.load_script(user, 'examples/scripts/blast.ol') }}
