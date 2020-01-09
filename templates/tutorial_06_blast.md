### NCBI BLAST+

OrthoLang provides the most common NCBI BLAST programs, which differ in their
subject and query types. See the Reference tab at the top for all the variants.

A couple examples:

_Note: Just ask if you want one of the more exotic ones added, like `rps-blast` or `delta-blast`._

_Note: `:help` for individual functions coming soon._

You can also download the standard NCBI databases. Try this:

{{ macros.load_cut(user, 'examples/cut-scripts/blast02.cut') }}

{{ macros.load_cut(user, 'examples/cut-scripts/blast01.cut') }}

The SwissProt DB will take a minute or two to download,
and then you should see a summary like this:

    Database: Non-redundant UniProtKB/SwissProt sequences
    469,560 sequences; 177,002,184 total residues
    Longest sequence: 35,213 residues
    Volumes: /tmp/tmpdirs/57862f1e67784c01814382ead3d122df/cache/blastdbget/swissprot.00

You can use it in any function that takes a protein database (`.pdb`).
