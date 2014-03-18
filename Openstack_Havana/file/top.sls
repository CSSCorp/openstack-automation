havana:
  {{ grains['id'] }}:
    - generics.headers
{% if 'cluster_ops.list_sls' in salt %}
{% for sls in salt['cluster_ops.list_sls']() %}
    - {{ sls }}
{% endfor %}
{% endif %}
