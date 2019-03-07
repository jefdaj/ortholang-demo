### PSI-BLAST

When making a cut you'll often want to do a sensitive search for distant
homologs, and PSI-BLAST (position-specific iterated blast) is usually the best
one for that. You do have to be a little careful though, because it's possible
for the search to be "poisoned": if the first BLASTP iteration picks up
unrelated proteins, and they have more hits in the database than your actual
protein of interest does, it will train itself to pick up more and more of the
wrong ones.

So if you only have one or a few genes to search for the best strategy is to
look through the results of each iteration on the NCBI site to make sure they
seem reasonable. Obviously that's not very high-throughput though. ShortCut
can't assess whether the results make sense, but you can use it to tune the
search settings to pick up known positive control genes while excluding as many
others as possible. That's the topic of the next section.

If you have a large number of similar genes, like a bunch of membrane
transporters, you might also try a hybrid strategy:

1. pick a few random ones with the `sample` function
2. confirm those work on the NCBI site
3. do them all in ShortCut
