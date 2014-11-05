{% for tenant_name in pillar['keystone']['tenants'] %}
{{ tenant_name }}_tenant:
  keystone:
    - tenant_present
    - name: {{ tenant_name }}
{% endfor %}
{% for role_name in pillar['keystone']['roles'] %}
{{ role_name }}_role:
  keystone:
    - role_present
    - name: {{ role_name }}
{% endfor %}
