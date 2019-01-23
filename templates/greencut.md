{% import "macros.jinja" as macros with context %}

Now you know everything you need to make an actual, useful cut.
Like, the kind you could publish!

{{ macros.load_example(user, 'green.rrr') }}

{{ macros.load_example(user, 'green-ids.rrr') }}
