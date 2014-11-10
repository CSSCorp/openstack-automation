{% from "cluster/resources.jinja" import get_candidate with context %}

{% for tenant_name in pillar['keystone']['tenants'] %}
{{ tenant_name }}_tenant:
  keystone:
    - tenant_present
    - name: {{ tenant_name }}
    - connection_token: {{ salt['pillar.get']('keystone:admin_token', default='ADMIN') }}
    - connection_endpoint: {{ salt['pillar.get']('keystone:services:keystone:endpoint:internalurl', default='http://{0}:35357/v2.0').format(get_candidate(salt['pillar.get']('keystone:services:keystone:endpoint:endpoint_host_sls', default='keystone'))) }}
{% endfor %}
{% for role_name in pillar['keystone']['roles'] %}
{{ role_name }}_role:
  keystone:
    - role_present
    - name: {{ role_name }}
    - connection_token: {{ salt['pillar.get']('keystone:admin_token', default='ADMIN') }}
    - connection_endpoint: {{ salt['pillar.get']('keystone:services:keystone:endpoint:internalurl', default='http://{0}:35357/v2.0').format(get_candidate(salt['pillar.get']('keystone:services:keystone:endpoint:endpoint_host_sls', default='keystone'))) }}
{% endfor %}
