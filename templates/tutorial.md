{% import "macros.jinja" as macros with context %}

The best way to use this tutorial is probably to
load each example and play around with it a bit as you go. That's the fastest
way to learn, and also the fastest way for me to get bug reports. Just type
them in the box on the lower right. Something short like "I did this and
expected this, but this happened instead" is fine. If the tutorial is
confusing, that counts as a bug too!

<input id="tutorialsearch" placeholder="Search the tutorial" id="box" type="text"/>

If you know what you want to learn about you can use the search to narrow it down by topic,
but it's probably less confusing to go through at least the first few sections in order.

<div id="tutorial">
{% for path in sections | sort() %}
	  {%- include "tutorialsection.md" -%}
{% endfor %}
</div>
