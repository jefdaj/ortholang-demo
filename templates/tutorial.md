{% import "macros.jinja" as macros with context %}

This is a fairly long and complete tutorial. Reading all of it and trying the
examples you should take you from zero to reproducible searches!
If that gets boring you can just read the first few sections, then
search for specific things you're interested in on the other tabs.

Don't forget to leave a bug report if something is broken! 
Type a short description of the issue in the box on the lower right,
like "I did \<something\> and expected \<this\>, but \<something else\> happened instead".
If the tutorial is confusing, that counts as a bug too.

<input id="tutorialsearch" placeholder="Filter tutorial sections" id="box" type="text"/>

Tutorial:

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
