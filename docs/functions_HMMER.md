### HMMER

Search sequences with hidden Markov models.

Types:

| Name      | Meaning |
| :-------- | :------ |
| <a href="javascript:;" onclick="help_and_scripts('faa')">`faa`</a> | FASTA (amino acid) |
| <a href="javascript:;" onclick="help_and_scripts('aln')">`aln`</a> | multiple sequence alignment |
| <a href="javascript:;" onclick="help_and_scripts('hmm')">`hmm`</a> | hidden markov model |
| <a href="javascript:;" onclick="help_and_scripts('hht')">`hht`</a> | HMMER hits table |

Functions:

| Name | Type |
| :--- | :--- |
| <a href="javascript:;" onclick="help_and_scripts('hmmbuild')">`hmmbuild`</a> | ` aln -> hmm` |
| <a href="javascript:;" onclick="help_and_scripts('hmmbuild_each')">`hmmbuild_each`</a> | ` aln.list -> hmm.list` |
| <a href="javascript:;" onclick="help_and_scripts('hmmsearch')">`hmmsearch`</a> | ` num hmm faa -> hht` |
| <a href="javascript:;" onclick="help_and_scripts('hmmsearch_each')">`hmmsearch_each`</a> | ` num hmm.list faa -> hht.list` |
| <a href="javascript:;" onclick="help_and_scripts('extract_hmm_targets')">`extract_hmm_targets`</a> | ` hht -> str.list` |
| <a href="javascript:;" onclick="help_and_scripts('extract_hmm_targets_each')">`extract_hmm_targets_each`</a> | ` hht.list -> str.list.list` |

<br/>
{{ macros.load_script(user, 'examples/scripts/hmmer.ol') }}
