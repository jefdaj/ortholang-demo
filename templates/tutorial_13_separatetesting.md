## Separate the main cut from testing code

_Note: This makes make more sense explained live in the screencast (coming soon)._

As you build a cut, you'll probably want to test variations on each step.
I've found that the easiest way to do it without developing a huge pile of messy variable names
is to make one script for the actual cut and another for each set of "experiments" on it.
For example this might be a good layout:

```
greencut/
├── unoptimized.ol
├── optimize-search-cutoff.ol
└── optimize-green-genomes.ol
```

Most code is in `unoptimized.ol`, with each thing you want to optimize assigned to a variable:
it should have `search_cutoff` and `green_genomes` along with anything you want to use in scoring like `n_hits`.
Then when you want to optimize one of them you do it in a new file like this:

```
include "unoptimized.ol"
n_hits_by_search_cutoff = score_repeats n_hits search_cutoff [1e-2, 1e-5, 1e-10, 1e-20, 1e-50]
result = linegraph "n hits by search cutoff" n_hits_by_search_cutoff
```

<!-- TODO need to demonstrate `minimize` or `maximize` functions here -->

If you don't get any difinitive answer to a particular question you can abandon that file with no extra mess.
But if it improves the cut you `include` the new improved version when optimizing the next thing.
At the end your code not only gives reasonable results, but is also easy to explain!
