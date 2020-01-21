{% import "macros.jinja" as macros with context %}

<div class="moduleblock" id="{{block['id']}}">
  {{ macros.markdown_doc(path) }}
</div>
