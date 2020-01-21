### Busco

Benchmarking Universal Single-Copy Orthologs.

Types:

| Name      | Meaning |
| :-------- | :------ |
| <a href="javascript:;" onclick="help_and_scripts('blh')">`blh`</a> | BUSCO lineage HMMs |
| <a href="javascript:;" onclick="help_and_scripts('bsr')">`bsr`</a> | BUSCO results |
| <a href="javascript:;" onclick="help_and_scripts('bst')">`bst`</a> | BUSCO scores table |
| <a href="javascript:;" onclick="help_and_scripts('faa')">`faa`</a> | FASTA (amino acid) |

Functions:

| Name | Type |
| :--- | :--- |
| <a href="javascript:;" onclick="help_and_scripts('load_lineage')">`load_lineage`</a> | ` str -> blh` |
| <a href="javascript:;" onclick="help_and_scripts('busco_list_lineages')">`busco_list_lineages`</a> | ` str -> str.list` |
| <a href="javascript:;" onclick="help_and_scripts('busco_fetch_lineage')">`busco_fetch_lineage`</a> | ` str -> blh` |
| <a href="javascript:;" onclick="help_and_scripts('busco_proteins')">`busco_proteins`</a> | ` blh faa -> bsr` |
| <a href="javascript:;" onclick="help_and_scripts('busco_proteins_each')">`busco_proteins_each`</a> | ` blh faa.list -> bsr.list` |
| <a href="javascript:;" onclick="help_and_scripts('busco_transcriptome')">`busco_transcriptome`</a> | ` blh fna -> bsr` |
| <a href="javascript:;" onclick="help_and_scripts('busco_transcriptome_each')">`busco_transcriptome_each`</a> | ` blh fna.list -> bsr.list` |
| <a href="javascript:;" onclick="help_and_scripts('busco_percent_complete')">`busco_percent_complete`</a> | ` bsr -> num` |
| <a href="javascript:;" onclick="help_and_scripts('busco_percent_complete_each')">`busco_percent_complete_each`</a> | ` bsr.list -> num.list` |
| <a href="javascript:;" onclick="help_and_scripts('busco_scores_table')">`busco_scores_table`</a> | ` bsr.list -> bst` |
| <a href="javascript:;" onclick="help_and_scripts('busco_filter_completeness')">`busco_filter_completeness`</a> | ` num bst faa.list -> faa.list` |
| <a href="javascript:;" onclick="help_and_scripts('concat_bst')">`concat_bst`</a> | ` bst.list -> bst` |

<br/>
{{ macros.load_script(user, 'examples/scripts/busco.ol') }}
