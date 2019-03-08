{% import "macros.jinja" as macros with context %}

This is a fairly long and complete tutorial. If you read all of it and try the
examples you should be able to go from zero to reproducible phylogenmic cuts!
If that gets boring you can also just read the first few sections, then
search for specific functions you're interested in using here and on the
Examples or Reference tabs.

Don't forget to leave Jeff a quick bug report if something is broken! 
Type a short description of the issue in the box on the lower right,
like "I did \<something\> and expected \<one thing\>, but \<other thing\> happened instead".
If the tutorial is confusing, that counts as a bug too.

<input id="tutorialsearch" placeholder="Search the tutorial" id="box" type="text"/>

<div id="tutorial">
{% for path in sections | sort() %}
	  {%- include "tutorialsection.md" -%}
{% endfor %}
</div>
