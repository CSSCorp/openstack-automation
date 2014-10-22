{% for server in salt['piller.get']('hosts', default={}) %}
{{ server }}:
  host
    - present
    - ip: {{ pillar['hosts'][server] }}
{% endfor %}
