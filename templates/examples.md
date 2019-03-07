{% import "macros.jinja" as macros with context %}

<input id="examplesearch" placeholder="Search the examples" id="box" type="text"/>

If you don't find what you're looking for, leave Jeff a comment about it! (bottom right)

{% for path in examples %}
  {%- filter markdown -%}
	{%- include "loadexample.html" -%}
  {%- endfilter -%}
{% endfor %}
