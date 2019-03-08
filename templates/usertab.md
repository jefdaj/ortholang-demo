{% import "macros.jinja" as macros with context %}

Scripts you saved in your user folder show up here.

You can `Load` and edit them like in the tutorial,
and `include` them inside each other to build up larger cuts.

<input id="userscriptsearch" placeholder="Search your scripts" id="box" type="text"/>

<div id="userscripts">
{% for path in userscripts %}
  {%- filter markdown -%}
	{%- include "loadexample.html" -%}
  {%- endfilter -%}
{% endfor %}
</div>
