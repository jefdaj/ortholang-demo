{% import "macros.jinja" as macros with context %}

{% if user == 'guest' %}

These scripts are written by other anonymous users.
`Load` and play around with them, or save your own and it'll show up here after a page refresh.

If you click "Sign in" and make up a username + password, you'll get:

* A private version of this page for just your scripts
* Terminal sessions that persist when you leave the page
* "Google Docs-style" collaborative editing by logging in from multiple computers

No other info is required, and nothing is stored about users except their password (hash) + scripts.

<input id="userscriptsearch" placeholder="Search guest scripts" id="box" type="text"/>

{% else %}

Scripts you saved in your user folder show up here after refreshing the page.

You can `Load` and edit them same as in the tutorial,
and `include` them inside each other to build up larger cuts.

<input id="userscriptsearch" placeholder="Search your scripts" id="box" type="text"/>

{% endif %}

<div id="userscripts">
{% for path in userscripts | sort() %}
  {%- filter markdown -%}
	{%- include "loadexample.html" -%}
  {%- endfilter -%}
{% endfor %}
</div>
