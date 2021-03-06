### Result and Other Variables

Let's start at the beginning.
This is probably the simplest script you could write:

{{ macros.load_script(user, 'examples/scripts/variables01.ol') }}

<!-- TODO include example scripts in the main repo? either that or rewrite this: -->
<!-- idea: :help <varname> should expand to help on its type -->
If you downloaded OrthoLang and ran `ortholang --script variables01.ol`, it would print
`"hello world!"`. You can also `Load` it in the demo terminal and type `result`.

You don't have to run a whole script at once though!
You can also define and evaluate individual variables.
Here is a script with several of them to demonstrate.

{{ macros.load_script(user, 'examples/scripts/variables02.ol') }}

OrthoLang keeps track of dependencies between variables, like this:

![]({{ url_for('static',filename='vars.svg') }})

You can evaluate one of them by typing its name.
Anything it depends on ("needs") will also get evaluated.
You can find what a given variable needs with the `:neededfor` command,
and what needs it with `:needs`.

{{ macros.run_example([':load examples/scripts/variables02.ol', ':neededfor var3', ':needs var3']) }}

`result` always holds the latest result.
If you type a plain expression like `4 * 4` without assigning it to a variable,
that becomes the new `result`.
You can also assign it yourself when the script is done to say what the final result should be.

So, if you type `result` or `var4` here the graph will stay the same and
OrthoLang will print `-1.485`. Then if you type `var2`, the graph will change to:

![]({{ url_for('static',filename='var2.svg') }})

And it will print `"nothing depends on var2 so far"`.... which technically isn't quite true anymore.
