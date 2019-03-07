{% import "macros.jinja" as macros with context %}

Here are a bunch of example scripts, including the ones from the rest of the site.

If you don't find what you're looking for, leave Jeff a comment about it! (bottom right)

<input id="examplesearch" placeholder="Search the examples" id="box" type="text"/>

<div id="examples">
{% for path in examples %}
  {%- filter markdown -%}
	{%- include "loadexample.html" -%}
  {%- endfilter -%}
{% endfor %}
</div>
