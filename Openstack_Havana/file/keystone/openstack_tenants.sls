<<<<<<< HEAD
=======
#!jinja|json
{
    "keystone-tenant-refresh-repo": {
		"module": [
			"run",
			{
				"name": "saltutil.sync_all"
			}
		]
    }
>>>>>>> cd189cab2257ed583018c889d11b66839b1262d7
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
