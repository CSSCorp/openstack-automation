{% from "cluster/resources.jinja" import get_candidate with context %}

{% for tenant_name in pillar['keystone']['tenants'] %}
{% for user_name in pillar['keystone']['tenants'][tenant_name]['users'] %}
{{ user_name }}_user:
  keystone:
    - user_present
    - name: {{ user_name }}
    - password: {{ pillar['keystone']['tenants'][tenant_name]['users'][user_name]['password'] }}
    - email: {{ pillar['keystone']['tenants'][tenant_name]['users'][user_name]['email'] }}
    - tenant: {{ tenant_name }}
    - roles:
      - {{ tenant_name }}:  {{ pillar['keystone']['tenants'][tenant_name]['users'][user_name]['roles'] }}
    - connection_token: {{ salt['pillar.get']('keystone:admin_token', default='ADMIN') }}
    - connection_endpoint: {{ salt['pillar.get']('keystone:services:keystone:endpoint:adminurl', default='http://{0}:35357/v2.0').format(get_candidate(salt['pillar.get']('keystone:services:keystone:endpoint:endpoint_host_sls', default='keystone'))) }}
{% endfor %}
{% endfor %}

