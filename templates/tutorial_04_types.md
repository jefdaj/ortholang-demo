### Types and Filetypes

<!-- TODO bug: brackets misplaced in :type of & -->

Before loading files and running BLAST, we need to detour and learn a couple
things about how OrthoLang evaluates code. If you skip this, things will be
confusing later!

The first important thing to know is that OrthoLang is a typed language. Types
are the standard technique for preventing a large and very annoying class of
bugs where the script crashes partway through because you accidentally swapped
two variables or misread how some function works.  The idea is that your
program should fail immediately if it's not going to work, because why waste
time? (Python is famously bad at this)

To catch errors the interpreter tags each thing (variable or expression) with a
type: "number", "string", "blast hit table", etc. You can ask OrthoLang the type
of anything with the `:type` command. For example, `:type "my string"` is `str`
and `:type var4` (from the example above) is `num`.

Each function has a "type signature" that says what types it accepts, and when
you try to call it with the wrong one the interpreter will stop you. Here are
the type signatures of a couple functions we've already used:

    * : num num -> num
    & : X.list X.list -> X.list

The first means that `*` takes two numbers and returns another number.

The second means "`&` (set intersection) takes two lists of any type X and
returns another list of the same type". So it works with lists of numbers or
lists of strings or lists of genomes, but you can't accidentally mix them.

You can see the types of all variables in your current script at once by typing
just `:type`. For the last example, it should look like:

```python
var1.num = 1.5
var2.str = "nothing needs var2 so far"
var3.num = 2.0e-3 * var1
var4.num = var3 * 5 - var1
result.num = var4
```

The second important thing to know is that in OrthoLang, every piece of code you
evaluate gets written to its own temporary file. That's the reason for the
weird dot notation above: types are equivalent to file extensions.
After evaluating `var4` you can look in the temporary directory and find a file
`vars/var4.num` with `-1.485` written in it. If you create a list of numbers
you'll get a `.num.list`. You can also make a `.num.list.list` and so on.
Look at the `:type`s of these:

{{ macros.load_script(user, 'examples/scripts/types01.ol') }}

This might seem like overkill at first, but becomes important for large-scale
bookkeeping. Imagine you have a few hundred thousand cryptically named
tempfiles. Your script chews through them for several days and finally returns
an empty list (`[]`). You want to be confident that there really are no hits,
instead of going back and poring over every command to make sure two files
didn't get mixed up somewhere!
