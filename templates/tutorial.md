{% import "macros.jinja" as macros with context %}

This is a fairly long and complete tutorial. If you read all of it and try the
examples you should be able to go from zero to reproducible phylogenmic cuts!
If that gets too long or boring you can also just read the first few sections, then
search for the specific functions you're interested in using here and on the
Examples tab.

Don't forget to leave Jeff a quick bug report if something is broken! Just type
them in the box on the lower right. Something short like "I did this and
expected this, but this happened instead" is fine. If the tutorial is
confusing, that counts as a bug too.

<input id="tutorialsearch" placeholder="Search the tutorial" id="box" type="text"/>

<div id="tutorial">
{% for path in sections | sort() %}
	  {%- include "tutorialsection.md" -%}
{% endfor %}
</div>
