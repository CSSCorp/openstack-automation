{% for server in salt['pillar.get']('hosts', default={}) %}
{{ server }}:
  host:
    - present
    - ip: {{ pillar['hosts'][server] }}
{% endfor %}
