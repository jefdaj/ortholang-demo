{% import "macros.jinja" as macros with context %}

Read sections 1-5 in order, then skip around the rest as needed if you get bored.
If something is broken or confusing, leave a comment or ask Jeff about it! (find my email [here][niyogilab])

<input id="tutorialsearch" placeholder="Filter tutorial sections" id="box" type="text"/>

<ul id="tutorial_toc" style="list-style-type: none;">
{% for path, section in sections.items() | sort(attribute='1.index') %}
		<li id="{{section['id']}}_toc" style="display: list-item";>
			{{sections[path]['index']}}. <a href="#{{section['id']}}"> {{ sections[path]['title'] }}</a>
		</li>
{% endfor %}
</ul>

<div id="tutorial">
{% for path, section in sections.items() | sort(attribute='1.index') %}
	  {%- include "tutorialsection.md" -%}
{% endfor %}
</div>

[niyogilab]: https://niyogilab.berkeley.edu/lab-directory
