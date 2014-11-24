{% for security_group in salt['pillar.get']('neutron:security_groups', ()) %}
openstack-security-group-{{ security_group }}:
  neutron:
    - security_group_present
    - name: {{ security_group }}
    - description: {{ salt['pillar.get']('neutron:security_groups:%s:description' % security_group, None) }}
    - rules: {{ salt['pillar.get']('neutron:security_groups:%s:rules' % security_group, []) }}
{% endfor %}
