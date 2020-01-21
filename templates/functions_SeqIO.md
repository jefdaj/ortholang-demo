### SeqIO

Sequence file manipulations using BioPython's SeqIO.

Types:

| Name      | Meaning |
| :-------- | :------ |
| <a href="javascript:;" onclick="help_and_scripts('gbk')">`gbk`</a> | genbank |
| <a href="javascript:;" onclick="help_and_scripts('faa')">`faa`</a> | FASTA (amino acid) |
| <a href="javascript:;" onclick="help_and_scripts('fna')">`fna`</a> | FASTA (nucleic acid) |
| <a href="javascript:;" onclick="help_and_scripts('fa')">`fa`</a> | FASTA (nucleic OR amino acid) |

Functions:

| Name | Type |
| :--- | :--- |
| <a href="javascript:;" onclick="help_and_scripts('gbk_to_faa')">`gbk_to_faa`</a> | ` str gbk -> faa` |
| <a href="javascript:;" onclick="help_and_scripts('gbk_to_faa_each')">`gbk_to_faa_each`</a> | ` str gbk.list -> faa.list` |
| <a href="javascript:;" onclick="help_and_scripts('gbk_to_fna')">`gbk_to_fna`</a> | ` str gbk -> fna` |
| <a href="javascript:;" onclick="help_and_scripts('gbk_to_fna_each')">`gbk_to_fna_each`</a> | ` str gbk.list -> fna.list` |
| <a href="javascript:;" onclick="help_and_scripts('extract_seqs')">`extract_seqs`</a> | ` fa str.list -> fa` |
| <a href="javascript:;" onclick="help_and_scripts('extract_seqs_each')">`extract_seqs_each`</a> | ` fa.list -> str.list.list` |
| <a href="javascript:;" onclick="help_and_scripts('extract_ids')">`extract_ids`</a> | ` fa -> str.list` |
| <a href="javascript:;" onclick="help_and_scripts('extract_ids_each')">`extract_ids_each`</a> | ` fa.list -> str.list.list` |
| <a href="javascript:;" onclick="help_and_scripts('translate')">`translate`</a> | ` fna -> faa` |
| <a href="javascript:;" onclick="help_and_scripts('translate_each')">`translate_each`</a> | ` fna.list -> faa.list` |
| <a href="javascript:;" onclick="help_and_scripts('concat_fna')">`concat_fna`</a> | ` fna.list -> fna` |
| <a href="javascript:;" onclick="help_and_scripts('concat_fna_each')">`concat_fna_each`</a> | ` fna.list.list -> fna.list` |
| <a href="javascript:;" onclick="help_and_scripts('concat_faa')">`concat_faa`</a> | ` faa.list -> faa` |
| <a href="javascript:;" onclick="help_and_scripts('concat_faa_each')">`concat_faa_each`</a> | ` faa.list.list -> faa.list` |
| <a href="javascript:;" onclick="help_and_scripts('split_faa')">`split_faa`</a> | ` faa -> faa.list` |
| <a href="javascript:;" onclick="help_and_scripts('split_faa_each')">`split_faa_each`</a> | ` faa.list -> faa.list.list` |
| <a href="javascript:;" onclick="help_and_scripts('split_fna')">`split_fna`</a> | ` fna -> fna.list` |
| <a href="javascript:;" onclick="help_and_scripts('split_fna_each')">`split_fna_each`</a> | ` fna.list -> fna.list.list` |
| <a href="javascript:;" onclick="help_and_scripts('load_fna')">`load_fna`</a> | ` str -> fna` |
| <a href="javascript:;" onclick="help_and_scripts('load_fna_each')">`load_fna_each`</a> | ` str.list -> fna.list` |
| <a href="javascript:;" onclick="help_and_scripts('load_fna_glob')">`load_fna_glob`</a> | ` str -> fna.list` |
| <a href="javascript:;" onclick="help_and_scripts('load_faa')">`load_faa`</a> | ` str -> faa` |
| <a href="javascript:;" onclick="help_and_scripts('load_faa_each')">`load_faa_each`</a> | ` str.list -> faa.list` |
| <a href="javascript:;" onclick="help_and_scripts('load_faa_glob')">`load_faa_glob`</a> | ` str -> faa.list` |
| <a href="javascript:;" onclick="help_and_scripts('load_gbk')">`load_gbk`</a> | ` str -> gbk` |
| <a href="javascript:;" onclick="help_and_scripts('load_gbk_each')">`load_gbk_each`</a> | ` str.list -> gbk.list` |
| <a href="javascript:;" onclick="help_and_scripts('load_gbk_glob')">`load_gbk_glob`</a> | ` str -> gbk.list` |

<br/>
{{ macros.load_script(user, 'examples/scripts/seqio.ol') }}
