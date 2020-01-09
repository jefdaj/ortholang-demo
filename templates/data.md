{% import "macros.jinja" as macros with context %}

You can use any FASTA or GenBank file with OrthoLang, but this page lists the standard ones pre-loaded on the demo server.
Clicking the load links below will type the corresponding `load_` function in the interpreter for you.

If there are many files for your species, try adding keywords: "brachy 460", "papaya faa", "araport11 protein primary", etc.

To assign variables, type the variable name first. For example: "arabidopsis =". Then click the `load` button to auto-fill the rest of the line.

Once you get the hang of it you can load your own files too:

1. Use the `Upload files` button to send them to the server
2. Type the appropriate `load_` function call

Note that anything you upload as `guest` will be available to other guest users.

<input id="datasearch" placeholder="Search demo data" id="box" type="text"/>

<table id="datatable">
<tr>
  <th width="4%">Type</th>
  <th width="10%%">Source</th>
  <th width="50%">Filename</th>
  <th width="46%">Description</th>
</tr>

{% for d in blastdbs | sort(attribute='basename') %}
<tr class="datablock">
	<td>{{d.type}}</td>
	<td>NCBI</td>
	<td><a href="#" onclick="repl_autorun([' {{d.loadfn | escape}}'], clear_first=false)"><pre>{{d.basename}}</pre></a></td>
	<td>{% if d.description is defined and d.description|length %}
		{{d.description}}
	{% endif %}</td>
</tr>
{% endfor %}

{% for d in genomes | sort(attribute='organism') %}
<tr class="datablock">
	<td>{{d.type}}</td>
	<td>Phytozome</td>
	<td><a href="#" onclick="repl_autorun([' {{d.loadfn | escape}}'], clear_first=false)"><pre>{{d.basename}}</pre></a></td>
	<td>
		<a href="{{d.url}}" target="_blank">{{d.organism}}</a>
		{% if d.commonname is defined and d.commonname|length %}
			({{d.commonname}})
		{% endif %}
	</td>
</tr>
{% endfor %}

</table>
