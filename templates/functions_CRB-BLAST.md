### CRB-BLAST

Conditional reciprocal BLAST best hits (Aubry et al. 2014).

Types:

| Type      | Meaning |
| :-------- | :------ |
| <a href="javascript:;" onclick="help_and_scripts('fna')">`fna`</a> | FASTA (nucleic acid) |
| <a href="javascript:;" onclick="help_and_scripts('faa')">`faa`</a> | FASTA (amino acid) |
| <a href="javascript:;" onclick="help_and_scripts('fa')">`fa`</a> | FASTA (nucleic OR amino acid) |
| <a href="javascript:;" onclick="help_and_scripts('crb')">`crb`</a> | tab-separated table of conditional reciprocal blast best hits |

Functions:

| Name | Type |
| :--- | :--- |
| <a href="javascript:;" onclick="help_and_scripts('crb_blast')">`crb_blast`</a> | ` fna fa -> crb` |
| <a href="javascript:;" onclick="help_and_scripts('crb_blast_each')">`crb_blast_each`</a> | ` fna fa.list -> crb.list` |

<br/>
{{ macros.load_script(user, 'examples/scripts/crbblast.ol') }}
