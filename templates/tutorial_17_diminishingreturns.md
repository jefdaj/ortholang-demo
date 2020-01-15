### Look for diminishing returns

If you're already using both the tips above (ramping up number of genes or genomes and scoring your results), consider plotting them against each other.
You might find that it's not worth using more than 5 genomes from a certain group, for example.

```
n_genomes = 5
result_score = ...
linegraph "how does the score change with more genomes?" result_score n_genomes [3,5,7,9,11]
```

Now you can ramp up by adding bigger numbers to the end of the list and get an updated plot each time.
