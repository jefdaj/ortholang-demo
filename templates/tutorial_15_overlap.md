### Score by overlap with a list of known genes

One good way to score your hits is by making a list of known "positive control" genes and checking how many of them you can rediscover.
The score can be the number of known genes found, fraction of known genes found, or fraction of your hits that are known genes (to penalize longer lists).

```
n_known_genes_found    = length (known_genes & my_results)
frac_known_genes_found = n_known_genes_found / (length known_genes)
frac_of_results_known  = n_known_genes_found / (length my_results)
```

Try out a few different scores and see what matches best with your intuition.
Just be sure to keep it relatively simple to minimize overfitting or p-hacking.
