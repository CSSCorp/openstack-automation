{% for file_required in salt['pillar.get']('files', default=()) %}
{{ file_required }}:
  file:
    - managed
{% for file_option in pillar['files'][file_required] %}
    - {{ file_option }}: {{ pillar['files'][file_required][file_option] }}
{% endfor %}
{% endfor %}
