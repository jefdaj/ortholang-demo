### Diamond

Accelerated BLAST compatible local sequence aligner..

Types:

| Type      | Meaning |
| :-------- | :------ |
| <a href="javascript:;" onclick="help_and_scripts('fna')">`fna`</a> | FASTA (nucleic acid) |
| <a href="javascript:;" onclick="help_and_scripts('faa')">`faa`</a> | FASTA (amino acid) |
| <a href="javascript:;" onclick="help_and_scripts('dmnd')">`dmnd`</a> | DIAMOND database |

Functions:

| Name | Type |
| :--- | :--- |
| <a href="javascript:;" onclick="help_and_scripts('diamond_makedb')">`diamond_makedb`</a> | ` faa -> dmnd` |
| <a href="javascript:;" onclick="help_and_scripts('diamond_makedb_each')">`diamond_makedb_each`</a> | ` faa.list -> dmnd.list` |
| <a href="javascript:;" onclick="help_and_scripts('diamond_makedb_all')">`diamond_makedb_all`</a> | ` faa.list -> dmnd` |
| <a href="javascript:;" onclick="help_and_scripts('diamond_blastp')">`diamond_blastp`</a> | ` num faa faa -> bht` |
| <a href="javascript:;" onclick="help_and_scripts('diamond_blastp_sensitive')">`diamond_blastp_sensitive`</a> | ` num faa faa -> bht` |
| <a href="javascript:;" onclick="help_and_scripts('diamond_blastp_more_sensitive')">`diamond_blastp_more_sensitive`</a> | ` num faa faa -> bht` |
| <a href="javascript:;" onclick="help_and_scripts('diamond_blastx')">`diamond_blastx`</a> | ` num fna faa -> bht` |
| <a href="javascript:;" onclick="help_and_scripts('diamond_blastx_sensitive')">`diamond_blastx_sensitive`</a> | ` num fna faa -> bht` |
| <a href="javascript:;" onclick="help_and_scripts('diamond_blastx_more_sensitive')">`diamond_blastx_more_sensitive`</a> | ` num fna faa -> bht` |
| <a href="javascript:;" onclick="help_and_scripts('diamond_blastp_rev')">`diamond_blastp_rev`</a> | ` num faa faa -> bht` |
| <a href="javascript:;" onclick="help_and_scripts('diamond_blastp_sensitive_rev')">`diamond_blastp_sensitive_rev`</a> | ` num faa faa -> bht` |
| <a href="javascript:;" onclick="help_and_scripts('diamond_blastp_more_sensitive_rev')">`diamond_blastp_more_sensitive_rev`</a> | ` num faa faa -> bht` |
| <a href="javascript:;" onclick="help_and_scripts('diamond_blastx_rev')">`diamond_blastx_rev`</a> | ` num faa fna -> bht` |
| <a href="javascript:;" onclick="help_and_scripts('diamond_blastx_sensitive_rev')">`diamond_blastx_sensitive_rev`</a> | ` num faa fna -> bht` |
| <a href="javascript:;" onclick="help_and_scripts('diamond_blastx_more_sensitive_rev')">`diamond_blastx_more_sensitive_rev`</a> | ` num faa fna -> bht` |
| <a href="javascript:;" onclick="help_and_scripts('diamond_blastp_db')">`diamond_blastp_db`</a> | ` num faa dmnd -> bht` |
| <a href="javascript:;" onclick="help_and_scripts('diamond_blastp_db_sensitive')">`diamond_blastp_db_sensitive`</a> | ` num faa dmnd -> bht` |
| <a href="javascript:;" onclick="help_and_scripts('diamond_blastp_db_more_sensitive')">`diamond_blastp_db_more_sensitive`</a> | ` num faa dmnd -> bht` |
| <a href="javascript:;" onclick="help_and_scripts('diamond_blastx_db')">`diamond_blastx_db`</a> | ` num fna dmnd -> bht` |
| <a href="javascript:;" onclick="help_and_scripts('diamond_blastx_db_sensitive')">`diamond_blastx_db_sensitive`</a> | ` num fna dmnd -> bht` |
| <a href="javascript:;" onclick="help_and_scripts('diamond_blastx_db_more_sensitive')">`diamond_blastx_db_more_sensitive`</a> | ` num fna dmnd -> bht` |
| <a href="javascript:;" onclick="help_and_scripts('diamond_blastp_db_rev')">`diamond_blastp_db_rev`</a> | ` num dmnd faa -> bht` |
| <a href="javascript:;" onclick="help_and_scripts('diamond_blastp_db_sensitive_rev')">`diamond_blastp_db_sensitive_rev`</a> | ` num dmnd faa -> bht` |
| <a href="javascript:;" onclick="help_and_scripts('diamond_blastp_db_more_sensitive_rev')">`diamond_blastp_db_more_sensitive_rev`</a> | ` num dmnd faa -> bht` |
| <a href="javascript:;" onclick="help_and_scripts('diamond_blastx_db_rev')">`diamond_blastx_db_rev`</a> | ` num dmnd fna -> bht` |
| <a href="javascript:;" onclick="help_and_scripts('diamond_blastx_db_sensitive_rev')">`diamond_blastx_db_sensitive_rev`</a> | ` num dmnd fna -> bht` |
| <a href="javascript:;" onclick="help_and_scripts('diamond_blastx_db_more_sensitive_rev')">`diamond_blastx_db_more_sensitive_rev`</a> | ` num dmnd fna -> bht` |
| <a href="javascript:;" onclick="help_and_scripts('diamond_blastp_each')">`diamond_blastp_each`</a> | ` num faa faa.list -> bht.list` |
| <a href="javascript:;" onclick="help_and_scripts('diamond_blastp_sensitive_each')">`diamond_blastp_sensitive_each`</a> | ` num faa faa.list -> bht.list` |
| <a href="javascript:;" onclick="help_and_scripts('diamond_blastp_more_sensitive_each')">`diamond_blastp_more_sensitive_each`</a> | ` num faa faa.list -> bht.list` |
| <a href="javascript:;" onclick="help_and_scripts('diamond_blastx_each')">`diamond_blastx_each`</a> | ` num fna faa.list -> bht.list` |
| <a href="javascript:;" onclick="help_and_scripts('diamond_blastx_sensitive_each')">`diamond_blastx_sensitive_each`</a> | ` num fna faa.list -> bht.list` |
| <a href="javascript:;" onclick="help_and_scripts('diamond_blastx_more_sensitive_each')">`diamond_blastx_more_sensitive_each`</a> | ` num fna faa.list -> bht.list` |
| <a href="javascript:;" onclick="help_and_scripts('diamond_blastp_rev_each')">`diamond_blastp_rev_each`</a> | ` num faa faa.list -> bht.list` |
| <a href="javascript:;" onclick="help_and_scripts('diamond_blastp_sensitive_rev_each')">`diamond_blastp_sensitive_rev_each`</a> | ` num faa faa.list -> bht.list` |
| <a href="javascript:;" onclick="help_and_scripts('diamond_blastp_more_sensitive_rev_each')">`diamond_blastp_more_sensitive_rev_each`</a> | ` num faa faa.list -> bht.list` |
| <a href="javascript:;" onclick="help_and_scripts('diamond_blastx_rev_each')">`diamond_blastx_rev_each`</a> | ` num faa fna.list -> bht.list` |
| <a href="javascript:;" onclick="help_and_scripts('diamond_blastx_sensitive_rev_each')">`diamond_blastx_sensitive_rev_each`</a> | ` num faa fna.list -> bht.list` |
| <a href="javascript:;" onclick="help_and_scripts('diamond_blastx_more_sensitive_rev_each')">`diamond_blastx_more_sensitive_rev_each`</a> | ` num faa fna.list -> bht.list` |
| <a href="javascript:;" onclick="help_and_scripts('diamond_blastp_db_each')">`diamond_blastp_db_each`</a> | ` num faa dmnd.list -> bht.list` |
| <a href="javascript:;" onclick="help_and_scripts('diamond_blastp_db_sensitive_each')">`diamond_blastp_db_sensitive_each`</a> | ` num faa dmnd.list -> bht.list` |
| <a href="javascript:;" onclick="help_and_scripts('diamond_blastp_db_more_sensitive_each')">`diamond_blastp_db_more_sensitive_each`</a> | ` num faa dmnd.list -> bht.list` |
| <a href="javascript:;" onclick="help_and_scripts('diamond_blastx_db_each')">`diamond_blastx_db_each`</a> | ` num fna dmnd.list -> bht.list` |
| <a href="javascript:;" onclick="help_and_scripts('diamond_blastx_db_sensitive_each')">`diamond_blastx_db_sensitive_each`</a> | ` num fna dmnd.list -> bht.list` |
| <a href="javascript:;" onclick="help_and_scripts('diamond_blastx_db_more_sensitive_each')">`diamond_blastx_db_more_sensitive_each`</a> | ` num fna dmnd.list -> bht.list` |

<br/>
{{ macros.load_script(user, 'examples/scripts/diamond.ol') }}
