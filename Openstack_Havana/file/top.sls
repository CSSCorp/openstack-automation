havana:
{% for cluster_component in pillar['install'] %}
{% for server in pillar[cluster_component] %}
  {{ server }}:
  {% for sls in pillar['install'][cluster_component] %}
    - {{ sls }}
  {% endfor %}
{% endfor %}
{% endfor %}
