{% import "macros.jinja" as macros with context %}

This is an auto-generated list of the available functions in OrthoLang v0.9.3.

The search box only filters by module. So for example if you search for
"mmseqs", you'll get the MMSeqs module but also BlastHits and ListLike, because
they can use MMSeqs results.

Click on the name of a type or function to display `:help` and example scripts.

<input id="modulesearch" placeholder="Search the module documentation" id="box" type="text"/>
<br/>

<!-- TODO Why does one extra moduleblock with div + empty line have to go here? -->
<div class="moduleblock">
<div></div>

</div>
<div class="moduleblock">
<h3>Replace module</h3>

Replace variables in the script to see how the results change.


Functions:

| Name | Type |
| :--- | :--- |
| <a href="javascript:;" onclick="help_and_scripts('replace')">`replace`</a> | ` <outputvar> <vartoreplace> <exprtoreplacewith> -> <newoutput>` |
| <a href="javascript:;" onclick="help_and_scripts('replace_each')">`replace_each`</a> | ` <outputvar> <inputvar> <inputvars> -> <output>.list` |

<br/>
{{ macros.load_script(user, 'examples/scripts/replace.ol') }}
</div>
<div class="moduleblock">
<h3>Repeat module</h3>

Repeatdly re-calculate variables using different random salts.


Functions:

| Name | Type |
| :--- | :--- |
| <a href="javascript:;" onclick="help_and_scripts('repeat')">`repeat`</a> | ` <outputvar> <inputvar> num -> <output>.list` |

<br/>
{{ macros.load_script(user, 'examples/scripts/repeat.ol') }}
</div>
<div class="moduleblock">
<h3>Math module</h3>

Basic math.


Functions:

| Name | Type |
| :--- | :--- |
| <a href="javascript:;" onclick="help_and_scripts('+')">`+`</a> | ` num num -> num` |
| <a href="javascript:;" onclick="help_and_scripts('-')">`-`</a> | ` num num -> num` |
| <a href="javascript:;" onclick="help_and_scripts('*')">`*`</a> | ` num num -> num` |
| <a href="javascript:;" onclick="help_and_scripts('/')">`/`</a> | ` num num -> num` |

<br/>
{{ macros.load_script(user, 'examples/scripts/math.ol') }}
</div>
<div class="moduleblock">
<h3>Load module</h3>

Load generic lists.


Functions:

| Name | Type |
| :--- | :--- |
| <a href="javascript:;" onclick="help_and_scripts('load_list')">`load_list`</a> | ` str -> str.list` |
| <a href="javascript:;" onclick="help_and_scripts('glob_files')">`glob_files`</a> | ` str -> str.list` |

<br/>
{{ macros.load_script(user, 'examples/scripts/load.ol') }}
</div>
<div class="moduleblock">
<h3>Sets module</h3>

Set operations for use with lists.


Functions:

| Name | Type |
| :--- | :--- |
| <a href="javascript:;" onclick="help_and_scripts('some')">`some`</a> | ` X.list.list -> X.list` |
| <a href="javascript:;" onclick="help_and_scripts('\|')">`|`</a> | ` X.list -> X.list -> X.list` |
| <a href="javascript:;" onclick="help_and_scripts('any')">`any`</a> | ` X.list.list -> X.list` |
| <a href="javascript:;" onclick="help_and_scripts('&')">`&`</a> | ` X.list -> X.list -> X.list` |
| <a href="javascript:;" onclick="help_and_scripts('all')">`all`</a> | ` X.list.list -> X.list` |
| <a href="javascript:;" onclick="help_and_scripts('~')">`~`</a> | ` X.list -> X.list -> X.list` |
| <a href="javascript:;" onclick="help_and_scripts('diff')">`diff`</a> | ` X.list.list -> X.list` |

<br/>
{{ macros.load_script(user, 'examples/scripts/sets.ol') }}
</div>
<div class="moduleblock">
<h3>SeqIO module</h3>

Sequence file manipulations using BioPython's SeqIO.

Types:

| Type      | Meaning |
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
</div>
<div class="moduleblock">
<h3>BiomartR module</h3>

Search + download genomes and proteomes from Biomart.

Types:

| Type      | Meaning |
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
</div>
<div class="moduleblock">
<h3>BlastDB module</h3>

Create, load, and download BLAST databases.

Types:

| Type      | Meaning |
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
</div>
<div class="moduleblock">
<h3>BLAST+ module</h3>

Standard NCBI BLAST+ functions.

Types:

| Type      | Meaning |
| :-------- | :------ |
| <a href="javascript:;" onclick="help_and_scripts('ndb')">`ndb`</a> | BLAST nucleotide database |
| <a href="javascript:;" onclick="help_and_scripts('pdb')">`pdb`</a> | BLAST protein database |
| <a href="javascript:;" onclick="help_and_scripts('bht')">`bht`</a> | tab-separated table of blast hits (outfmt 6) |

Functions:

| Name | Type |
| :--- | :--- |
| <a href="javascript:;" onclick="help_and_scripts('blastn')">`blastn`</a> | ` num fna fna -> bht` |
| <a href="javascript:;" onclick="help_and_scripts('megablast')">`megablast`</a> | ` num fna fna -> bht` |
| <a href="javascript:;" onclick="help_and_scripts('blastp')">`blastp`</a> | ` num faa faa -> bht` |
| <a href="javascript:;" onclick="help_and_scripts('blastx')">`blastx`</a> | ` num fna faa -> bht` |
| <a href="javascript:;" onclick="help_and_scripts('tblastn')">`tblastn`</a> | ` num faa fna -> bht` |
| <a href="javascript:;" onclick="help_and_scripts('tblastx')">`tblastx`</a> | ` num fna fna -> bht` |
| <a href="javascript:;" onclick="help_and_scripts('blastn_each')">`blastn_each`</a> | ` num fna fna.list -> bht.list` |
| <a href="javascript:;" onclick="help_and_scripts('megablast_each')">`megablast_each`</a> | ` num fna fna.list -> bht.list` |
| <a href="javascript:;" onclick="help_and_scripts('blastp_each')">`blastp_each`</a> | ` num faa faa.list -> bht.list` |
| <a href="javascript:;" onclick="help_and_scripts('blastx_each')">`blastx_each`</a> | ` num fna faa.list -> bht.list` |
| <a href="javascript:;" onclick="help_and_scripts('tblastn_each')">`tblastn_each`</a> | ` num faa fna.list -> bht.list` |
| <a href="javascript:;" onclick="help_and_scripts('tblastx_each')">`tblastx_each`</a> | ` num fna fna.list -> bht.list` |
| <a href="javascript:;" onclick="help_and_scripts('blastn_db')">`blastn_db`</a> | ` num fna ndb -> bht` |
| <a href="javascript:;" onclick="help_and_scripts('megablast_db')">`megablast_db`</a> | ` num fna ndb -> bht` |
| <a href="javascript:;" onclick="help_and_scripts('blastp_db')">`blastp_db`</a> | ` num faa pdb -> bht` |
| <a href="javascript:;" onclick="help_and_scripts('blastx_db')">`blastx_db`</a> | ` num fna pdb -> bht` |
| <a href="javascript:;" onclick="help_and_scripts('tblastn_db')">`tblastn_db`</a> | ` num faa ndb -> bht` |
| <a href="javascript:;" onclick="help_and_scripts('tblastx_db')">`tblastx_db`</a> | ` num fna ndb -> bht` |
| <a href="javascript:;" onclick="help_and_scripts('blastn_db_each')">`blastn_db_each`</a> | ` num fna ndb.list -> bht.list` |
| <a href="javascript:;" onclick="help_and_scripts('megablast_db_each')">`megablast_db_each`</a> | ` num fna ndb.list -> bht.list` |
| <a href="javascript:;" onclick="help_and_scripts('blastp_db_each')">`blastp_db_each`</a> | ` num faa pdb.list -> bht.list` |
| <a href="javascript:;" onclick="help_and_scripts('blastx_db_each')">`blastx_db_each`</a> | ` num fna pdb.list -> bht.list` |
| <a href="javascript:;" onclick="help_and_scripts('tblastn_db_each')">`tblastn_db_each`</a> | ` num faa ndb.list -> bht.list` |
| <a href="javascript:;" onclick="help_and_scripts('tblastx_db_each')">`tblastx_db_each`</a> | ` num fna ndb.list -> bht.list` |
| <a href="javascript:;" onclick="help_and_scripts('concat_bht')">`concat_bht`</a> | ` bht.list -> bht` |
| <a href="javascript:;" onclick="help_and_scripts('concat_bht_each')">`concat_bht_each`</a> | ` bht.list.list -> bht.list` |

<br/>
{{ macros.load_script(user, 'examples/scripts/blast.ol') }}
</div>
<div class="moduleblock">
<h3>BlastHits module</h3>

Work with BLAST hit tables.

Types:

| Type      | Meaning |
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
</div>
<div class="moduleblock">
<h3>ListLike module</h3>

Operations on files that can be treated like lists.

Types:

| Type      | Meaning |
| :-------- | :------ |
| <a href="javascript:;" onclick="help_and_scripts('bht')">`bht`</a> | tab-separated table of blast hits (outfmt 6) |
| <a href="javascript:;" onclick="help_and_scripts('crb')">`crb`</a> | tab-separated table of conditional reciprocal blast best hits |
| <a href="javascript:;" onclick="help_and_scripts('mms')">`mms`</a> | MMSeqs2 sequence database |
| <a href="javascript:;" onclick="help_and_scripts('listlike')">`listlike`</a> | files that can be treated like lists |

Functions:

| Name | Type |
| :--- | :--- |
| <a href="javascript:;" onclick="help_and_scripts('length')">`length`</a> | ` listlike -> num` |
| <a href="javascript:;" onclick="help_and_scripts('length_each')">`length_each`</a> | ` listlike.list -> num.list` |

<br/>
{{ macros.load_script(user, 'examples/scripts/listlike.ol') }}
</div>
<div class="moduleblock">
<h3>PsiBLAST module</h3>

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
</div>
<div class="moduleblock">
<h3>CRB-BLAST module</h3>

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
</div>
<div class="moduleblock">
<h3>HMMER module</h3>

Search sequences with hidden Markov models.

Types:

| Type      | Meaning |
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
</div>
<div class="moduleblock">
<h3>BlastRBH module</h3>

Reciprocal BLAST+ best hits.

Types:

| Type      | Meaning |
| :-------- | :------ |
| <a href="javascript:;" onclick="help_and_scripts('faa')">`faa`</a> | FASTA (amino acid) |
| <a href="javascript:;" onclick="help_and_scripts('ndb')">`ndb`</a> | BLAST nucleotide database |
| <a href="javascript:;" onclick="help_and_scripts('pdb')">`pdb`</a> | BLAST protein database |
| <a href="javascript:;" onclick="help_and_scripts('bht')">`bht`</a> | tab-separated table of blast hits (outfmt 6) |

Functions:

| Name | Type |
| :--- | :--- |
| <a href="javascript:;" onclick="help_and_scripts('blastn_rev')">`blastn_rev`</a> | ` num fna fna -> bht` |
| <a href="javascript:;" onclick="help_and_scripts('megablast_rev')">`megablast_rev`</a> | ` num fna fna -> bht` |
| <a href="javascript:;" onclick="help_and_scripts('blastp_rev')">`blastp_rev`</a> | ` num faa faa -> bht` |
| <a href="javascript:;" onclick="help_and_scripts('tblastx_rev')">`tblastx_rev`</a> | ` num fna fna -> bht` |
| <a href="javascript:;" onclick="help_and_scripts('blastn_rev_each')">`blastn_rev_each`</a> | ` num fna fna.list -> bht.list` |
| <a href="javascript:;" onclick="help_and_scripts('megablast_rev_each')">`megablast_rev_each`</a> | ` num fna fna.list -> bht.list` |
| <a href="javascript:;" onclick="help_and_scripts('blastp_rev_each')">`blastp_rev_each`</a> | ` num faa faa.list -> bht.list` |
| <a href="javascript:;" onclick="help_and_scripts('tblastx_rev_each')">`tblastx_rev_each`</a> | ` num fna fna.list -> bht.list` |
| <a href="javascript:;" onclick="help_and_scripts('reciprocal_best')">`reciprocal_best`</a> | ` bht bht -> bht` |
| <a href="javascript:;" onclick="help_and_scripts('reciprocal_best_all')">`reciprocal_best_all`</a> | ` bht.list bht.list -> bht` |
| <a href="javascript:;" onclick="help_and_scripts('blastn_rbh')">`blastn_rbh`</a> | ` num fna fna -> bht` |
| <a href="javascript:;" onclick="help_and_scripts('megablast_rbh')">`megablast_rbh`</a> | ` num fna fna -> bht` |
| <a href="javascript:;" onclick="help_and_scripts('blastp_rbh')">`blastp_rbh`</a> | ` num faa faa -> bht` |
| <a href="javascript:;" onclick="help_and_scripts('tblastx_rbh')">`tblastx_rbh`</a> | ` num fna fna -> bht` |
| <a href="javascript:;" onclick="help_and_scripts('blastn_rbh_each')">`blastn_rbh_each`</a> | ` num fna fna.list -> bht.list` |
| <a href="javascript:;" onclick="help_and_scripts('megablast_rbh_each')">`megablast_rbh_each`</a> | ` num fna fna.list -> bht.list` |
| <a href="javascript:;" onclick="help_and_scripts('blastp_rbh_each')">`blastp_rbh_each`</a> | ` num faa faa.list -> bht.list` |
| <a href="javascript:;" onclick="help_and_scripts('tblastx_rbh_each')">`tblastx_rbh_each`</a> | ` num fna fna.list -> bht.list` |

<br/>
{{ macros.load_script(user, 'examples/scripts/blastrbh.ol') }}
</div>
<div class="moduleblock">
<h3>MUSCLE module</h3>

Align sequences with MUSCLE.

Types:

| Type      | Meaning |
| :-------- | :------ |
| <a href="javascript:;" onclick="help_and_scripts('faa')">`faa`</a> | FASTA (amino acid) |
| <a href="javascript:;" onclick="help_and_scripts('aln')">`aln`</a> | multiple sequence alignment |

Functions:

| Name | Type |
| :--- | :--- |
| <a href="javascript:;" onclick="help_and_scripts('muscle')">`muscle`</a> | ` faa -> aln` |
| <a href="javascript:;" onclick="help_and_scripts('muscle_each')">`muscle_each`</a> | ` faa.list -> aln.list` |

<br/>
{{ macros.load_script(user, 'examples/scripts/muscle.ol') }}
</div>
<div class="moduleblock">
<h3>Sample module</h3>

Random (but reproducable) sampling of list elements.

WARNING: Because of the way OrthoLang caches tempfiles, calling these
more than once will give the same sublist each time! For different
sublists, use in combination with the 'repeat' function.


Functions:

| Name | Type |
| :--- | :--- |
| <a href="javascript:;" onclick="help_and_scripts('sample')">`sample`</a> | ` num X.list -> X.list` |

<br/>
{{ macros.load_script(user, 'examples/scripts/sample.ol') }}
</div>
<div class="moduleblock">
<h3>Permute module</h3>

Generate random permutations of lists.


Functions:

| Name | Type |
| :--- | :--- |
| <a href="javascript:;" onclick="help_and_scripts('leave_each_out')">`leave_each_out`</a> | ` X.list -> X.list.list` |

<br/>
{{ macros.load_script(user, 'examples/scripts/permute.ol') }}
</div>
<div class="moduleblock">
<h3>Summarize module</h3>

Collapse a list of results into a single summary.



<br/>
{{ macros.load_script(user, 'examples/scripts/summarize.ol') }}
</div>
<div class="moduleblock">
<h3>Scores module</h3>

Score repeated variables for plotting.


Functions:

| Name | Type |
| :--- | :--- |
| <a href="javascript:;" onclick="help_and_scripts('score_repeats')">`score_repeats`</a> | ` <outputnum> <inputvar> <inputlist> -> <input>.scores` |
| <a href="javascript:;" onclick="help_and_scripts('extract_scores')">`extract_scores`</a> | ` X.scores -> num.list` |
| <a href="javascript:;" onclick="help_and_scripts('extract_scored')">`extract_scored`</a> | ` X.scores -> X.list` |

<br/>
{{ macros.load_script(user, 'examples/scripts/scores.ol') }}
</div>
<div class="moduleblock">
<h3>Plots module</h3>

Generate half-decent plots.

Types:

| Type      | Meaning |
| :-------- | :------ |
| <a href="javascript:;" onclick="help_and_scripts('png')">`png`</a> | plot image |

Functions:

| Name | Type |
| :--- | :--- |
| <a href="javascript:;" onclick="help_and_scripts('histogram')">`histogram`</a> | ` str num.list -> png` |
| <a href="javascript:;" onclick="help_and_scripts('linegraph')">`linegraph`</a> | ` str num.scores -> png` |
| <a href="javascript:;" onclick="help_and_scripts('scatterplot')">`scatterplot`</a> | ` str num.scores -> png` |
| <a href="javascript:;" onclick="help_and_scripts('venndiagram')">`venndiagram`</a> | ` X.list.list -> png` |

<br/>
{{ macros.load_script(user, 'examples/scripts/plots.ol') }}
</div>
<div class="moduleblock">
<h3>OrthoFinder module</h3>

Inference of orthologs, orthogroups, the rooted species, gene trees and gene duplcation events tree.

Types:

| Type      | Meaning |
| :-------- | :------ |
| <a href="javascript:;" onclick="help_and_scripts('faa')">`faa`</a> | FASTA (amino acid) |
| <a href="javascript:;" onclick="help_and_scripts('ofr')">`ofr`</a> | OrthoFinder results |

Functions:

| Name | Type |
| :--- | :--- |
| <a href="javascript:;" onclick="help_and_scripts('orthofinder')">`orthofinder`</a> | ` faa.list -> ofr` |

<br/>
{{ macros.load_script(user, 'examples/scripts/orthofinder.ol') }}
</div>
<div class="moduleblock">
<h3>Diamond module</h3>

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
</div>
<div class="moduleblock">
<h3>MMSeqs module</h3>

Many-against-many sequence searching: ultra fast and sensitive search and clustering suite.

Types:

| Type      | Meaning |
| :-------- | :------ |
| <a href="javascript:;" onclick="help_and_scripts('faa')">`faa`</a> | FASTA (amino acid) |
| <a href="javascript:;" onclick="help_and_scripts('fna')">`fna`</a> | FASTA (nucleic acid) |
| <a href="javascript:;" onclick="help_and_scripts('bht')">`bht`</a> | tab-separated table of blast hits (outfmt 6) |
| <a href="javascript:;" onclick="help_and_scripts('mms')">`mms`</a> | MMSeqs2 sequence database |

Functions:

| Name | Type |
| :--- | :--- |
| <a href="javascript:;" onclick="help_and_scripts('mmseqs_createdb_all')">`mmseqs_createdb_all`</a> | ` fa.list -> mms` |
| <a href="javascript:;" onclick="help_and_scripts('mmseqs_createdb')">`mmseqs_createdb`</a> | ` fa -> mms` |
| <a href="javascript:;" onclick="help_and_scripts('mmseqs_search_db')">`mmseqs_search_db`</a> | ` num fa mms -> bht` |
| <a href="javascript:;" onclick="help_and_scripts('mmseqs_search')">`mmseqs_search`</a> | ` num fa fa -> bht` |

<br/>
{{ macros.load_script(user, 'examples/scripts/mmseqs.ol') }}
</div>
<div class="moduleblock">
<h3>SonicParanoid module</h3>

Very fast, accurate, and easy orthology..

Types:

| Type      | Meaning |
| :-------- | :------ |
| <a href="javascript:;" onclick="help_and_scripts('faa')">`faa`</a> | FASTA (amino acid) |
| <a href="javascript:;" onclick="help_and_scripts('fna')">`fna`</a> | FASTA (nucleic acid) |
| <a href="javascript:;" onclick="help_and_scripts('spr')">`spr`</a> | SonicParanoid results |

Functions:

| Name | Type |
| :--- | :--- |
| <a href="javascript:;" onclick="help_and_scripts('sonicparanoid')">`sonicparanoid`</a> | ` faa.list -> spr` |

<br/>
{{ macros.load_script(user, 'examples/scripts/sonicparanoid.ol') }}
</div>
<div class="moduleblock">
<h3>OrthoGroups module</h3>

Common interface for working with the results of OrthoFinder, SonicParanoid, etc..

Types:

| Type      | Meaning |
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
</div>
<div class="moduleblock">
<h3>Busco module</h3>

Benchmarking Universal Single-Copy Orthologs.

Types:

| Type      | Meaning |
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
</div>
<div class="moduleblock">
<h3>Range module</h3>

Generate ranges of numbers.

Types:

| Type      | Meaning |
| :-------- | :------ |
| <a href="javascript:;" onclick="help_and_scripts('num')">`num`</a> | number in scientific notation |

Functions:

| Name | Type |
| :--- | :--- |
| <a href="javascript:;" onclick="help_and_scripts('range_add')">`range_add`</a> | ` num num num -> num.list` |
| <a href="javascript:;" onclick="help_and_scripts('range_exponent')">`range_exponent`</a> | ` num num num num -> num.list` |
| <a href="javascript:;" onclick="help_and_scripts('range_integers')">`range_integers`</a> | ` num num -> num.list` |
| <a href="javascript:;" onclick="help_and_scripts('range_length')">`range_length`</a> | ` num num num -> num.list` |
| <a href="javascript:;" onclick="help_and_scripts('range_multiply')">`range_multiply`</a> | ` num num num -> num.list` |

<br/>
{{ macros.load_script(user, 'examples/scripts/range.ol') }}
</div>
<div class="moduleblock">
<h3>SetsTable module</h3>

Generate set membership tables (spreadsheets) for easier list comparison.

Types:

| Type      | Meaning |
| :-------- | :------ |
| <a href="javascript:;" onclick="help_and_scripts('tsv')">`tsv`</a> | set membership table (spreadsheet) |

Functions:

| Name | Type |
| :--- | :--- |
| <a href="javascript:;" onclick="help_and_scripts('sets_table')">`sets_table`</a> | ` lit.list.list -> tsv` |

<br/>
{{ macros.load_script(user, 'examples/scripts/setstable.ol') }}
</div>
<div class="moduleblock">
<h3>All-Vs-All module</h3>

Creates all-vs-all hit tables from any BLAST-like search for use in ortholog finding algorithms.

Types:

| Type      | Meaning |
| :-------- | :------ |
| <a href="javascript:;" onclick="help_and_scripts('ava')">`ava`</a> | all-vs-all hit table listing |


<br/>
{{ macros.load_script(user, 'examples/scripts/allvsall.ol') }}
</div>
<div class="moduleblock">
<h3>GreenCut module</h3>

A re-implementation of the original GreenCut(2) ortholog-finding algorithm.

Types:

| Type      | Meaning |
| :-------- | :------ |
| <a href="javascript:;" onclick="help_and_scripts('gcr')">`gcr`</a> | GreenCut results |

Functions:

| Name | Type |
| :--- | :--- |
| <a href="javascript:;" onclick="help_and_scripts('greencut2_families')">`greencut2_families`</a> | ` bht bht -> gcr` |

<br/>
{{ macros.load_script(user, 'examples/scripts/greencut.ol') }}
</div>
