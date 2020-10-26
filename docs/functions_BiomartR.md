### BiomartR

Search + download genomes and proteomes from Biomart.

Types:

| Name      | Meaning |
| :-------- | :------ |
| <a href="javascript:;" onclick="help_and_scripts('search')">`search`</a> | intermediate table describing biomartr searches |
| <a href="javascript:;" onclick="help_and_scripts('fna.gz')">`fna.gz`</a> | gzipped fasta nucleic acid acid (gene list or genome) |
| <a href="javascript:;" onclick="help_and_scripts('faa.gz')">`faa.gz`</a> | gzipped fasta amino acid (proteome) |

Functions:

| Name | Type |
| :--- | :--- |
| <a href="javascript:;" onclick="help_and_scripts('parse_searches')">`parse_searches`</a> | ` str.list -> search` |
| <a href="javascript:;" onclick="help_and_scripts('get_genomes')">`get_genomes`</a> | ` str.list -> fna.gz.list` |
| <a href="javascript:;" onclick="help_and_scripts('get_proteomes')">`get_proteomes`</a> | ` str.list -> faa.gz.list` |

<br/>
{{ macros.load_script(user, 'examples/scripts/biomartr.ol') }}
