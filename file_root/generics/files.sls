{% for file-required in salt['pillar.get']('files', default=()) %}
{{ file-required }}:
  file:
    - managed
{% for file_option in pillar['files'][file-required] %}
    - {{ file_option }}: {{ pillar['files'][file-required][file_option]
{% endfor %}
{% endfor %}
