This page is a list of design patterns I've found helpful.
You can mix and match them as needed to create your cut.
If you want to do something not listed here, leave a comment or email me and I'll see if I can think of a way.
Or if you figure it out, also tell me that so I can add it here!


## Start small/fast and gradually increase the computations

Whenever I'm doing something that may require a lot of genes or genomes, I try it out first with a few and then increase it. That lets me check that it works quickly, and estimate the total runtime.
Just add a `sample` call and a variable saying how many to sample:

```
n_genomes = 5
genomes_to_use = sample n_genomes all_genomes
```

Set it to `length all_genomes` or some big number like `999999` to use them all.


## Separate the main cut from testing code

_Note: This makes make more sense explained live in the screencast (coming soon)._

As you build a cut, you'll probably want to test variations on each step.
I've found that the easiest way to do it without developing a huge pile of messy variable names
is to make one script for the actual cut and another for each set of "experiments" on it.
For example this might be a good layout:

```
greencut/
├── unoptimized.dtr
├── optimize-search-cutoff.dtr
└── optimize-green-genomes.dtr
```

Most code is in `unoptimized.dtr`, with each thing you want to optimize assigned to a variable:
it should have `search_cutoff` and `green_genomes` along with anything you want to use in scoring like `n_hits`.
Then when you want to optimize one of them you do it in a new file like this:

```
include "unoptimized.dtr"
n_hits_by_search_cutoff = score_repeats n_hits search_cutoff [1e-2, 1e-5, 1e-10, 1e-20, 1e-50]
result = linegraph "n hits by search cutoff" n_hits_by_search_cutoff
```

<!-- TODO need to demonstrate `minimize` or `maximize` functions here -->

If you don't get any difinitive answer to a particular question you can abandon that file with no extra mess.
But if it improves the cut you `include` the new improved version when optimizing the next thing.
At the end your code not only gives reasonable results, but is also easy to explain!


## Come up with scoring criteria, then optimize

Once you have an initial list of candidate genes, consider tweaking it a bit before you go and put weeks or months into cloning!
The general idea is you need way to score your list, and then you can try to maximize/minimize that score.


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


### Filter by robustness

Note that this is for deciding which genes will go in your final list, whereas the methods above are for deciding how much you trust that list.
Basically, you perturb the input genes + genomes and only keep the results that are consistent.

<!-- TODO finish writing this -->

## Look for diminishing returns

If you're already using both the tips above (ramping up number of genes or genomes and scoring your results), consider plotting them against each other.
You might find that it's not worth using more than 5 genomes from a certain group, for example.

```
n_genomes = 5
result_score = ...
linegraph "how does the score change with more genomes?" result_score n_genomes [3,5,7,9,11]
```

Now you can ramp up by adding bigger numbers to the end of the list and get an updated plot each time.
