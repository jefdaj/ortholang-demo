{%- macro load_example(name) -%}
  {%- with path=name -%}
    {%- include "loadexample.html" -%}
  {%- endwith -%}
{%- endmacro -%}


{% if user == 'guest' %}

Interested in collaborating on a cut script, or want a new feature?
Create an account, then email Jeff or leave a comment about it.
We can put work on it together and keep notes + code here.

{% else %}

<!-- TODO render user collaboration page here -->
Welcome back, {{ user }}!

{% endif %}

<!--
{{ load_example('green.cut') }}

{{ load_example('green-ids.cut') }}
-->
