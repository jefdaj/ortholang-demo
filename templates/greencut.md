{%- macro load_example(name) -%}
  {%- with path=name -%}
    {%- include "loadexample.html" -%}
  {%- endwith -%}
{%- endmacro -%}

Now you know everything you need to make an actual, useful cut.
Like, the kind you could publish!

{{ load_example('green.cut') }}

{{ load_example('green-ids.cut') }}
