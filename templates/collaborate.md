{%- macro markdown_doc(user) -%}
  {%- filter markdown -%}
    {%- include [user + '/collaborate.md'] ignore missing -%}
  {%- endfilter -%}
{%- endmacro -%}

{%- macro load_example(name) -%}
  {%- with path=name -%}
    {%- include "loadcode.html" -%}
  {%- endwith -%}
{%- endmacro -%}

<!-- TODO put the above blurb here unless the user collaborate.md exists already -->

{{ markdown_doc(user) }}
