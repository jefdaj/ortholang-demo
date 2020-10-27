{% import "macros.jinja" as macros with context %}

This page lists some standard data files pre-downloaded on the demo server:

* BLAST databases from NCBI
* Genomes and proteomes from Phytozome

Clicking a filename below will type the corresponding `load_` function in the interpreter for you.
Type keywords to filter the table: "papaya faa", "refseq", "araport11 protein primary", etc.
To assign variables, type the variable name in the terminal first.
For example: "arabidopsis =". Then click the filename to auto-fill the rest of the line.

Once you get the hang of it you can load your own files:

1. Use the `Upload files` button to send them to the server
2. Type the appropriate `load_` function call

Note that anything you upload as `guest` will be available to other guest users.

<input id="datasearch" placeholder="Search demo files" id="box" type="text"/>

<table id="datatable">
<thead>
  <th width="4%">Type</th>
  <th width="10%%">Source</th>
  <th width="50%">Filename</th>
  <th width="46%">Description</th>
</thead>

{% for d in blastdbs | sort(attribute='basename') %}
<tr class="datablock">
	<td>{{d.type}}</td>
	<td>NCBI</td>
	<td><a href="#" title='{{d.loadfn | escape}}' onclick="repl_autorun([' {{d.loadfn | escape}}'], clear_first=false)"><pre>{{d.basename[:50]}}</pre></a></td>
	<td>{% if d.description is defined and d.description|length %}
		{{d.description}}
	{% endif %}</td>
</tr>
{% endfor %}

{% for d in fastas | sort(attribute='organism') %}
<tr class="datablock">
	<td>{{d.type}}</td>
	<td>Phytozome</td>
	<td>
		<a href="#" title='{{d.loadfn | escape}}' onclick="repl_autorun([' {{d.loadfn | escape}}'], clear_first=false)"><pre>{{d.basename}}</pre></a>
	</td>
	<td>
		<a href="{{d.url}}" target="_blank">{{d.organism}}</a>
		{% if d.commonname is defined and d.commonname|length %}
			({{d.commonname}})
		{% endif %}
	</td>
</tr>
{% endfor %}

</table>
