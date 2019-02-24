{% import "macros.jinja" as macros with context %}

Now you know everything you need to make an actual, useful cut.
Like, the kind you could publish!

{{ macros.load_cut(user, 'examples/green.cut') }}

{{ macros.load_cut(user, 'examples/green-ids.cut') }}
