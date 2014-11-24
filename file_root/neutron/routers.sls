{% for router in salt['pillar.get']('neutron:routers', ()) %}
openstack-router-{{ router }}:
  neutron:
    - router_present
{% for router_param in salt['pillar.get']('neutron:routers:%s' % router, ()) %}
    - {{ router_param }}: {{ pillar['neutron']['routers'][router][router_param] }}
{% endfor %}
{% endfor %}
