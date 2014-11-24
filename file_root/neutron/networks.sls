{% for network in salt['pillar.get']('neutron:networks', ()) %}
openstack-network-{{ network }}:
  neutron:
    - network_present
    - name: {{ network }}
{% for network_param in salt['pillar.get']('neutron:networks:%s' % network, ()) %}
{% if not network_param == 'subnets' %}
    - {{ network_param }}: {{ pillar['neutron']['networks'][network][network_param] }}
{% endif %}
{% endfor %}
{% for subnet in salt['pillar.get']('neutron:networks:%s:subnets' % network, ()) %}
openstack-subnet-{{ subnet }}:
  neutron:
    - subnet_present
    - name: {{ subnet }}
    - network: {{ network }}
{% for subnet_param in salt['pillar.get']('neutron:networks:%s:subnets:%s' % (network, subnet), ()) %}
    - {{ subnet_param }}: {{ pillar['neutron']['networks'][network]['subnets'][subnet][subnet_param] }}
{% endfor %}
{% endfor %}
{% endfor %}
