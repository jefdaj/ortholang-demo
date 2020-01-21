{% import "macros.jinja" as macros with context %}

This is an auto-generated list of types and functions in {{ version }}.
Click on a name to display `:help` and relevant example scripts.

The search box filters by module. So for example if you search for
"mmseqs", you'll get the MMSeqs module but also BlastHits and ListLike, because
they can use MMSeqs results.

<input id="modulesearch" placeholder="Search the module documentation" id="box" type="text"/>
<br/>

<ul id="modules_toc" style="list-style-type: none;">
{% for path, block in modules.items() | sort(attribute='1.index') %}
		<li id="{{block['id']}}_toc" style="list-style-type: square;">
			<a href="#{{block['id']}}"> {{ block['title'] }}</a>
		</li>
{% endfor %}
</ul>

<div id="modules">
<!-- TODO Why does one extra moduleblock with div + empty line have to go here? -->
<div class="moduleblock">
<div></div>

</div>
{% for path, block in modules.items() | sort(attribute='1.index') %}
	  {%- include "moduleblock.md" -%}
{% endfor %}
</div>
