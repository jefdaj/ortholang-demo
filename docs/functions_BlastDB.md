### BlastDB

Create, load, and download BLAST databases.

Types:

| Name      | Meaning |
| :-------- | :------ |
| <a href="javascript:;" onclick="help_and_scripts('ndb')">`ndb`</a> | BLAST nucleotide database |
| <a href="javascript:;" onclick="help_and_scripts('pdb')">`pdb`</a> | BLAST protein database |

Functions:

| Name | Type |
| :--- | :--- |
| <a href="javascript:;" onclick="help_and_scripts('load_nucl_db')">`load_nucl_db`</a> | ` str -> ndb` |
| <a href="javascript:;" onclick="help_and_scripts('load_prot_db')">`load_prot_db`</a> | ` str -> pdb` |
| <a href="javascript:;" onclick="help_and_scripts('load_nucl_db_each')">`load_nucl_db_each`</a> | ` str.list -> ndb.list` |
| <a href="javascript:;" onclick="help_and_scripts('load_prot_db_each')">`load_prot_db_each`</a> | ` str.list -> pdb.list` |
| <a href="javascript:;" onclick="help_and_scripts('makeblastdb_nucl_all')">`makeblastdb_nucl_all`</a> | ` fa.list -> ndb` |
| <a href="javascript:;" onclick="help_and_scripts('makeblastdb_prot_all')">`makeblastdb_prot_all`</a> | ` faa.list -> pdb` |
| <a href="javascript:;" onclick="help_and_scripts('makeblastdb_nucl')">`makeblastdb_nucl`</a> | ` fa -> ndb` |
| <a href="javascript:;" onclick="help_and_scripts('makeblastdb_prot')">`makeblastdb_prot`</a> | ` faa -> pdb` |
| <a href="javascript:;" onclick="help_and_scripts('makeblastdb_nucl_each')">`makeblastdb_nucl_each`</a> | ` fa.list -> ndb.list` |
| <a href="javascript:;" onclick="help_and_scripts('makeblastdb_prot_each')">`makeblastdb_prot_each`</a> | ` faa.list -> pdb.list` |
| <a href="javascript:;" onclick="help_and_scripts('blastdbget_nucl')">`blastdbget_nucl`</a> | ` str -> ndb` |
| <a href="javascript:;" onclick="help_and_scripts('blastdbget_prot')">`blastdbget_prot`</a> | ` str -> pdb` |
| <a href="javascript:;" onclick="help_and_scripts('blastdblist')">`blastdblist`</a> | ` str -> str.list` |
| <a href="javascript:;" onclick="help_and_scripts('singletons')">`singletons`</a> | ` X.list -> X.list.list` |

<br/>
{{ macros.load_script(user, 'examples/scripts/blastdb.ol') }}
