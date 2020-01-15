### Start small/fast and gradually increase the computations

Whenever I'm doing something that may require a lot of genes or genomes, I try it out first with a few and then increase it. That lets me check that it works quickly, and estimate the total runtime.
Just add a `sample` call and a variable saying how many to sample:

```
n_genomes = 5
genomes_to_use = sample n_genomes all_genomes
```

Set it to `length all_genomes` or some big number like `999999` to use them all.
