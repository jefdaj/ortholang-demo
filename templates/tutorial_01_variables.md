### Result and Other Variables

Let's start at the beginning.
This is probably the simplest script you could write:

{{ macros.load_cut(user, 'examples/variables01.cut') }}

<!-- TODO include example scripts in the main repo? either that or rewrite this: -->
<!-- idea: :help <varname> should expand to help on its type -->
If you downloaded ShortCut and ran `shortcut --script variables01.cut`, it would print
`"hello world!"`. You can also `Load` it in the demo terminal and type `result`.

You don't have to run a whole script at once though.
You'll spend most of your time editing it in the interpreter,
defining and evaluating individual variables.
Here is a script with several of them.

{{ macros.load_cut(user, 'examples/variables02.cut') }}

ShortCut keeps track of dependencies between variables, like this:

![]({{ url_for('static',filename='vars.svg') }})

You can evaluate one of them by typing its name.
Anything it depends on ("needs") will also get evaluated.
You can find what a given variable needs with the `:neededfor` command,
and what needs it with `:needs`.

`result` always holds the latest result.
If you type a plain expression like `4 * 4` without assigning it to a variable,
that becomes the new `result`.
You can also assign it yourself when the script is done to say what the final result should be.

So, if you type `result` or `var4` here the graph will stay the same and
ShortCut will print `-1.485`. Then if you type `var2`, the graph will change to:

![]({{ url_for('static',filename='var2.svg') }})

And it will print `"nothing depends on var2 so far"`.... which technically isn't quite true anymore.
