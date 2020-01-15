{% import "macros.jinja" as macros with context %}

<div class="tutorialsection" id="{{section['id']}}">
  {{ macros.markdown_doc(path) }}
</div>
