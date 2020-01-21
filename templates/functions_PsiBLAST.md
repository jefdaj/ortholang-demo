### PsiBLAST

Iterated PsiBLAST (BLAST+) searches using position-specific substitution matrixes.

There are a lot of these! Some naming conventions:

* A fn with `train` trains and returns one or more pssms ; one without
`train` runs a regular blast search and returns hits.

* A fn with `db` takes one or more blast databases directly; one without
`db` auto-builds the db(s) from one or more fastas.

* A fn with `all` takes a list of fastas and creates one db from it.

* A fn with `each` maps over its last argument. The difference between
`each` and `all` is that `each` returns a list of results, whereas `all`
summarizes them into one thing.

* A fn with `pssms` (plural) takes a list of pssm queries and combines
their hits into one big table.

So for example...


```
psiblast_train_all : num faa faa.list -> pssm
  auto-builds one blast db from a list of fasta files
  trains a pssm for the query fasta on it
  returns the pssm
```

```
psiblast_each : num faa faa.list -> bht.list
  auto-builds one db per subject fasta
  trains a pssm for the query fasta against each one
  runs a final psiblast search against each one using the pssm
  returns a list of hit tables
```

TODO individual help descriptions for each fn.

Types:

| Type      | Meaning |
| :-------- | :------ |
| <a href="javascript:;" onclick="help_and_scripts('faa')">`faa`</a> | FASTA (amino acid) |
| <a href="javascript:;" onclick="help_and_scripts('pdb')">`pdb`</a> | BLAST protein database |
| <a href="javascript:;" onclick="help_and_scripts('bht')">`bht`</a> | tab-separated table of blast hits (outfmt 6) |
| <a href="javascript:;" onclick="help_and_scripts('pssm')">`pssm`</a> | PSI-BLAST position-specific substitution matrix as ASCII |

Functions:

| Name | Type |
| :--- | :--- |
| <a href="javascript:;" onclick="help_and_scripts('psiblast')">`psiblast`</a> | ` num faa faa -> bht` |
| <a href="javascript:;" onclick="help_and_scripts('psiblast_all')">`psiblast_all`</a> | ` num faa faa.list -> bht` |
| <a href="javascript:;" onclick="help_and_scripts('psiblast_db')">`psiblast_db`</a> | ` num faa pdb -> bht` |
| <a href="javascript:;" onclick="help_and_scripts('psiblast_db_each')">`psiblast_db_each`</a> | ` num faa pdb.list -> bht.list` |
| <a href="javascript:;" onclick="help_and_scripts('psiblast_each')">`psiblast_each`</a> | ` num faa faa.list -> bht.list` |
| <a href="javascript:;" onclick="help_and_scripts('psiblast_each_pssm')">`psiblast_each_pssm`</a> | ` num pssm.list faa -> bht.list` |
| <a href="javascript:;" onclick="help_and_scripts('psiblast_each_pssm_db')">`psiblast_each_pssm_db`</a> | ` num pssm.list pdb -> bht.list` |
| <a href="javascript:;" onclick="help_and_scripts('psiblast_pssm')">`psiblast_pssm`</a> | ` num pssm faa -> bht` |
| <a href="javascript:;" onclick="help_and_scripts('psiblast_pssm_all')">`psiblast_pssm_all`</a> | ` num pssm faa.list -> bht` |
| <a href="javascript:;" onclick="help_and_scripts('psiblast_pssm_db')">`psiblast_pssm_db`</a> | ` num pssm pdb -> bht` |
| <a href="javascript:;" onclick="help_and_scripts('psiblast_pssm_db_each')">`psiblast_pssm_db_each`</a> | ` num pssm pdb.list -> bht.list` |
| <a href="javascript:;" onclick="help_and_scripts('psiblast_pssm_each')">`psiblast_pssm_each`</a> | ` num pssm faa.list -> bht.list` |
| <a href="javascript:;" onclick="help_and_scripts('psiblast_pssms')">`psiblast_pssms`</a> | ` num pssm.list faa -> bht` |
| <a href="javascript:;" onclick="help_and_scripts('psiblast_pssms_all')">`psiblast_pssms_all`</a> | ` num pssm.list faa -> bht` |
| <a href="javascript:;" onclick="help_and_scripts('psiblast_pssms_db')">`psiblast_pssms_db`</a> | ` num pssm.list pdb -> bht` |
| <a href="javascript:;" onclick="help_and_scripts('psiblast_train')">`psiblast_train`</a> | ` num faa faa -> pssm` |
| <a href="javascript:;" onclick="help_and_scripts('psiblast_train_all')">`psiblast_train_all`</a> | ` num faa faa.list -> pssm` |
| <a href="javascript:;" onclick="help_and_scripts('psiblast_train_db')">`psiblast_train_db`</a> | ` num faa pdb -> pssm` |
| <a href="javascript:;" onclick="help_and_scripts('psiblast_train_db_each')">`psiblast_train_db_each`</a> | ` num faa pdb.list -> pssm.list` |
| <a href="javascript:;" onclick="help_and_scripts('psiblast_train_each')">`psiblast_train_each`</a> | ` num faa faa.list -> pssm.list` |
| <a href="javascript:;" onclick="help_and_scripts('psiblast_train_pssms')">`psiblast_train_pssms`</a> | ` num faa.list faa -> pssm.list` |
| <a href="javascript:;" onclick="help_and_scripts('psiblast_train_pssms_db')">`psiblast_train_pssms_db`</a> | ` num faa.list pdb -> pssm.list` |

<br/>
{{ macros.load_script(user, 'examples/scripts/psiblast.ol') }}
