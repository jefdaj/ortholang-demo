{% import "macros.jinja" as macros with context %}

Here are a bunch of example scripts, including everything from the rest of the site.

If you don't find an example similar to what you're trying to do, request that it be added (bottom right).
Or if you figure it out yourself, consider adding your script to the collection!
Jeff can anonymize it by switching out the genes and genomes involved
if you aren't comfortable putting up pre-publication work.

<input id="examplesearch" placeholder="Search the examples" id="box" type="text"/>

<div id="examples">
{% for path in examples | sort() %}
  {%- filter markdown -%}
	{%- include "loadexample.html" -%}
  {%- endfilter -%}
{% endfor %}
</div>
