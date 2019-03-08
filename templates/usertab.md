{% import "macros.jinja" as macros with context %}

{% if user == 'guest' %}

These scripts are written by other anonymous users.
`Load` and play around with them, or save your own and it'll show up here (after a page refresh).

Then, consider signing up for an account! You'll get:

* A private version of this page for just your scripts
* Terminal sessions that persist when you leave the page
* "Google Docs-style" collaborative editing by logging in from multiple computers

No email or signup form is required. Just click the button in the upper right and make up a username + password.
If you want to be notified of updates, leave your email in the comment box.

<input id="userscriptsearch" placeholder="Search guest scripts" id="box" type="text"/>

{% else %}

Scripts you saved in your user folder show up here (after refreshing the page).

You can `Load` and edit them same as in the tutorial,
and `include` them inside each other to build up larger cuts.

<input id="userscriptsearch" placeholder="Search your scripts" id="box" type="text"/>

{% endif %}

<div id="userscripts">
{% for path in userscripts %}
  {%- filter markdown -%}
	{%- include "loadexample.html" -%}
  {%- endfilter -%}
{% endfor %}
</div>
