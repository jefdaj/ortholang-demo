{% import "macros.jinja" as macros with context %}

You can load any FASTA or GenBank file in ShortCut, but a few standard ones are also pre-downloaded on the demo server for convenience.

Clicking the load links below will type the corresponding `load_` function in the interpreter for you.

<!-- TODO fix repl_autorun to enable this: -->
<!-- To assign variables, type the variable name first. For example: "arabidopsis = ". Then click the `load` button to auto-fill the rest of the line. -->

Once you get the hang of it you can load your own files too:

1. Use the `Upload files` button to send them to the server
2. Check that they showed up in your user folder with `glob_files "*"`
3. Type the appropriate `load_` function call

Note that anything you upload as `guest` will be available to other guest users.

<input id="genomesearch" placeholder="Search example genomes" id="box" type="text"/>

<table id="genomes">
<tr>
  <th>Organism</th>
  <!-- <th>Source</th> -->
  <th>Common name</th>
  <th>Type</th>
  <th>Load command</th>
</tr>
{% for g in genomes %}
<tr class="genomeblock">
	<td><a href="{{g.url}}" target="_blank">{{g.organism}}</a></td>
	<!-- <td>{{g.source}}</td> -->
	<td>{{g.common}}</td>
	<td>{{g.type}}</td>
	<td><a href="#" onclick="javascript:repl_autorun(['{{g.loadfn | escape}}'])">{{g.loadfn}}</a></td>
</tr>
{% endfor %}
</table>
