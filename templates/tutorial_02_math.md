### Math

Math is pretty simple. It works like you would expect, except that everything
is left-to-right rather than following order of operations.

A few examples:

{{ macros.load_cut(user, 'examples/math01.cut') }}

You can enter numbers in decimal or scientific notation. There's only one type
of number instead of the several different ones like doubles and floats you
would find in a typical language. Parentheses also work the regular "mathy" way
to group things together; you'll see a little further down that function
application doesn't use them.

Notice that ShortCut might remove your parentheses automatically,
but only where it doesn't change the meaning.