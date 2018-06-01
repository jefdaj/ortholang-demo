This page is a list of design patterns I've found helpful.
You can mix and match them as needed to create your cut.
If you want to do something not listed here, leave a comment or email me and I'll see if I can think of a way.
Or if you figure it out, also tell me that so I can add it here!


Start small and gradually increase the number of computations
-------------------------------------------------------------

Whenever I'm doing something that will require a lot of genes or genomes, I try it out first with a few and then increase it to estimate the runtime.
Just add a `sample` call and a variable saying how many to sample. Here it is with two variables at once:

```
# start these small, then increase
n_seqs = 20
n_genomes = 5

seqs_to_use = sample n_seqs (split_faa my_query_genome)
genomes_to_use = sample n_genomes all_genomes
```


Come up with scoring criteria, then optimize
--------------------------------------------

Once you have an initial list of candidate genes, consider tweaking it a bit before you go and put weeks or months into cloning!
The general idea is you need way to score your list, and then you can try to maximize/minimize that score.


Score by overlap with a list of known genes
-------------------------------------------

One good way to score your hits is by making a list of known "positive control" genes and checking how many of them you find.
The score can be the number of known genes found, fraction of known genes found, or fraction of your hits that are known genes (to penalize longer lists).

```
n_known_genes_found    = length (known_genes & my_results)
frac_known_genes_found = n_known_genes_found / (length known_genes)
frac_of_results_known  = n_known_genes_found / (length my_results)
```

Try out a few different scores and see what matches best with your intuition.
Just be sure to keep it relatively simple to minimize overfitting or p-hacking.


Filter by robustness
--------------------

Note that this is for deciding which genes will go in your final list, whereas the methods above are for deciding how much you trust that list.
Basically, you perturb the input genes + genomes and only keep the results that are consistent.


Look for diminishing returns
----------------------------

If you're already using both the tips above (ramping up number of genomes and scoring your results), consider plotting them against each other.
You might find that it's not worth using more than 5 genomes from a certain group, for example.

```
n_genomes = 5
result_score = ...
linegraph "how does the score change with more genomes?" result_score n_genomes [3,5,7,9,11]
```

Now you can ramp up by adding bigger numbers to the end of the list and get an updated plot each time.
