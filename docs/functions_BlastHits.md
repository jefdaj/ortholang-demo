### BlastHits

Work with BLAST hit tables.

Types:

| Name      | Meaning |
| :-------- | :------ |
| <a href="javascript:;" onclick="help_and_scripts('bht')">`bht`</a> | tab-separated table of blast hits (outfmt 6) |
| <a href="javascript:;" onclick="help_and_scripts('crb')">`crb`</a> | tab-separated table of conditional reciprocal blast best hits |
| <a href="javascript:;" onclick="help_and_scripts('hittable')">`hittable`</a> | BLAST hit table-like |

Functions:

| Name | Type |
| :--- | :--- |
| <a href="javascript:;" onclick="help_and_scripts('extract_queries')">`extract_queries`</a> | ` hittable -> str.list` |
| <a href="javascript:;" onclick="help_and_scripts('extract_queries_each')">`extract_queries_each`</a> | ` hittable.list -> str.list.list` |
| <a href="javascript:;" onclick="help_and_scripts('extract_targets')">`extract_targets`</a> | ` hittable -> str.list` |
| <a href="javascript:;" onclick="help_and_scripts('extract_targets_each')">`extract_targets_each`</a> | ` hittable.list -> str.list.list` |
| <a href="javascript:;" onclick="help_and_scripts('filter_evalue')">`filter_evalue`</a> | ` num hittable -> bht` |
| <a href="javascript:;" onclick="help_and_scripts('filter_evalue_each')">`filter_evalue_each`</a> | ` num hittable.list -> bht.list` |
| <a href="javascript:;" onclick="help_and_scripts('filter_bitscore')">`filter_bitscore`</a> | ` num hittable -> bht` |
| <a href="javascript:;" onclick="help_and_scripts('filter_bitscore_each')">`filter_bitscore_each`</a> | ` num hittable.list -> bht.list` |
| <a href="javascript:;" onclick="help_and_scripts('filter_pident')">`filter_pident`</a> | ` num hittable -> bht` |
| <a href="javascript:;" onclick="help_and_scripts('filter_pident_each')">`filter_pident_each`</a> | ` num hittable.list -> bht.list` |
| <a href="javascript:;" onclick="help_and_scripts('best_hits')">`best_hits`</a> | ` hittable -> bht` |
| <a href="javascript:;" onclick="help_and_scripts('best_hits_each')">`best_hits_each`</a> | ` hittable.list -> bht.list` |

<br/>
{{ macros.load_script(user, 'examples/scripts/blasthits.ol') }}
