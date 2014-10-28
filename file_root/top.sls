juno:
  "*.juno":
    - generics.*
{% for sls in salt['cluster_ops.list_sls']() %}
    - {{ sls }}
{% endfor %}
