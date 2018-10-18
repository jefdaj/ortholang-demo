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

{% if user == 'guest' %}

Interested in collaborating on a cut script, or want a new feature?
Create an account, then email Jeff or leave a comment about it.
We can put work on it together and keep notes + code here.

{% else %}

<!-- TODO put the above blurb here unless the user collaborate.md exists already -->

{{ markdown_doc(user) }}

{% endif %}
