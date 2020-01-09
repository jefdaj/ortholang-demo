{% import "macros.jinja" as macros with context %}

Now you know everything you need to make an actual, useful.ol.
Like, the kind you could publish!

{{ macros.load_script(user, 'examples/scripts/greencut.ol') }}

{{ macros.load_script(user, 'examples/scripts/green-ids.ol') }}
