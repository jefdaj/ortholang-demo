### OrthoGroups

Common interface for working with the results of OrthoFinder, SonicParanoid, etc..

Types:

| Name      | Meaning |
| :-------- | :------ |
| <a href="javascript:;" onclick="help_and_scripts('og')">`og`</a> | orthogroups (orthofinder, sonicparanoid, or greencut results) |
| <a href="javascript:;" onclick="help_and_scripts('ofr')">`ofr`</a> | OrthoFinder results |
| <a href="javascript:;" onclick="help_and_scripts('spr')">`spr`</a> | SonicParanoid results |
| <a href="javascript:;" onclick="help_and_scripts('gcr')">`gcr`</a> | GreenCut results |

Functions:

| Name | Type |
| :--- | :--- |
| <a href="javascript:;" onclick="help_and_scripts('orthogroups')">`orthogroups`</a> | ` og -> str.list.list` |
| <a href="javascript:;" onclick="help_and_scripts('orthogroup_containing')">`orthogroup_containing`</a> | ` og str -> str.list` |
| <a href="javascript:;" onclick="help_and_scripts('orthogroups_containing')">`orthogroups_containing`</a> | ` og str.list -> str.list.list` |
| <a href="javascript:;" onclick="help_and_scripts('ortholog_in_any')">`ortholog_in_any`</a> | ` og faa.list -> str.list.list` |
| <a href="javascript:;" onclick="help_and_scripts('ortholog_in_all')">`ortholog_in_all`</a> | ` og faa.list -> str.list.list` |
| <a href="javascript:;" onclick="help_and_scripts('ortholog_in_min')">`ortholog_in_min`</a> | ` num og faa.list -> str.list.list` |
| <a href="javascript:;" onclick="help_and_scripts('ortholog_in_max')">`ortholog_in_max`</a> | ` num og faa.list -> str.list.list` |
| <a href="javascript:;" onclick="help_and_scripts('ortholog_in_any_str')">`ortholog_in_any_str`</a> | ` str.list.list str.list.list -> str.list.list` |
| <a href="javascript:;" onclick="help_and_scripts('ortholog_in_all_str')">`ortholog_in_all_str`</a> | ` str.list.list str.list.list -> str.list.list` |
| <a href="javascript:;" onclick="help_and_scripts('ortholog_in_min_str')">`ortholog_in_min_str`</a> | ` num str.list.list str.list.list -> str.list.list` |
| <a href="javascript:;" onclick="help_and_scripts('ortholog_in_max_str')">`ortholog_in_max_str`</a> | ` num str.list.list str.list.list -> str.list.list` |

<br/>
{{ macros.load_script(user, 'examples/scripts/orthogroups.ol') }}
