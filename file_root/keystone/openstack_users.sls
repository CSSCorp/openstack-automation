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
{% endfor %}
{% endfor %}

