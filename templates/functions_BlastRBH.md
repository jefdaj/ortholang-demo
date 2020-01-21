### BlastRBH

Reciprocal BLAST+ best hits.

Types:

| Type      | Meaning |
| :-------- | :------ |
| <a href="javascript:;" onclick="help_and_scripts('faa')">`faa`</a> | FASTA (amino acid) |
| <a href="javascript:;" onclick="help_and_scripts('ndb')">`ndb`</a> | BLAST nucleotide database |
| <a href="javascript:;" onclick="help_and_scripts('pdb')">`pdb`</a> | BLAST protein database |
| <a href="javascript:;" onclick="help_and_scripts('bht')">`bht`</a> | tab-separated table of blast hits (outfmt 6) |

Functions:

| Name | Type |
| :--- | :--- |
| <a href="javascript:;" onclick="help_and_scripts('blastn_rev')">`blastn_rev`</a> | ` num fna fna -> bht` |
| <a href="javascript:;" onclick="help_and_scripts('megablast_rev')">`megablast_rev`</a> | ` num fna fna -> bht` |
| <a href="javascript:;" onclick="help_and_scripts('blastp_rev')">`blastp_rev`</a> | ` num faa faa -> bht` |
| <a href="javascript:;" onclick="help_and_scripts('tblastx_rev')">`tblastx_rev`</a> | ` num fna fna -> bht` |
| <a href="javascript:;" onclick="help_and_scripts('blastn_rev_each')">`blastn_rev_each`</a> | ` num fna fna.list -> bht.list` |
| <a href="javascript:;" onclick="help_and_scripts('megablast_rev_each')">`megablast_rev_each`</a> | ` num fna fna.list -> bht.list` |
| <a href="javascript:;" onclick="help_and_scripts('blastp_rev_each')">`blastp_rev_each`</a> | ` num faa faa.list -> bht.list` |
| <a href="javascript:;" onclick="help_and_scripts('tblastx_rev_each')">`tblastx_rev_each`</a> | ` num fna fna.list -> bht.list` |
| <a href="javascript:;" onclick="help_and_scripts('reciprocal_best')">`reciprocal_best`</a> | ` bht bht -> bht` |
| <a href="javascript:;" onclick="help_and_scripts('reciprocal_best_all')">`reciprocal_best_all`</a> | ` bht.list bht.list -> bht` |
| <a href="javascript:;" onclick="help_and_scripts('blastn_rbh')">`blastn_rbh`</a> | ` num fna fna -> bht` |
| <a href="javascript:;" onclick="help_and_scripts('megablast_rbh')">`megablast_rbh`</a> | ` num fna fna -> bht` |
| <a href="javascript:;" onclick="help_and_scripts('blastp_rbh')">`blastp_rbh`</a> | ` num faa faa -> bht` |
| <a href="javascript:;" onclick="help_and_scripts('tblastx_rbh')">`tblastx_rbh`</a> | ` num fna fna -> bht` |
| <a href="javascript:;" onclick="help_and_scripts('blastn_rbh_each')">`blastn_rbh_each`</a> | ` num fna fna.list -> bht.list` |
| <a href="javascript:;" onclick="help_and_scripts('megablast_rbh_each')">`megablast_rbh_each`</a> | ` num fna fna.list -> bht.list` |
| <a href="javascript:;" onclick="help_and_scripts('blastp_rbh_each')">`blastp_rbh_each`</a> | ` num faa faa.list -> bht.list` |
| <a href="javascript:;" onclick="help_and_scripts('tblastx_rbh_each')">`tblastx_rbh_each`</a> | ` num fna fna.list -> bht.list` |

<br/>
{{ macros.load_script(user, 'examples/scripts/blastrbh.ol') }}
