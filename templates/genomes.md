{% import "macros.jinja" as macros with context %}

You can use any FASTA or GenBank file with ShortCut, but this page lists the standard ones pre-loaded on the demo server.
Clicking the load links below will type the corresponding `load_` function in the interpreter for you.

If there are many files for your species, try adding keywords: "brachy 460", "papaya faa", "araport11 protein primary", etc.

To assign variables, type the variable name first. For example: "arabidopsis =". Then click the `load` button to auto-fill the rest of the line.

Once you get the hang of it you can load your own files too:

1. Use the `Upload files` button to send them to the server
2. Type the appropriate `load_` function call

Note that anything you upload as `guest` will be available to other guest users.

<input id="genomesearch" placeholder="Search demo genomes" id="box" type="text"/>

<table id="genomes">
<tr>
  <th>Load command</th>
  <th>Organism</th>
  <!-- <th>Source</th> -->
  <th>Common name</th>
</tr>
{% for g in genomes | sort(attribute='organism') %}
<tr class="genomeblock">
	<td><a href="#" onclick="repl_autorun([' {{g.loadfn | escape}}'], clear_first=false)">{{g.loadfn}}</a></td>
	<td><a href="{{g.url}}" target="_blank">{{g.organism}}</a></td>
	<!-- <td>{{g.source}}</td> -->
	<td>{{g.commonname}}</td>
</tr>
{% endfor %}
</table>
