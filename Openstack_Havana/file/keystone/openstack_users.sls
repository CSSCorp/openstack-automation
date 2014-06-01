{% for tenant_name in pillar['keystone']['tenants'] %}
{% for user_name in pillar['keystone']['tenants'][tenant_name]['users'] %}
<<<<<<< HEAD
{{ user_name }}_user:
  keystone
    - user_present
    - name: {{ user_name }}
    - password: {{ pillar['keystone']['tenants'][tenant_name]['users'][user_name]['password'] }}
    - email: {{ pillar['keystone']['tenants'][tenant_name]['users'][user_name]['email'] }}
    - tenant: {{ tenant_name }}
    - roles:
      - {{ tenant_name }}:  {{ pillar['keystone']['tenants'][tenant_name]['users'][user_name]['roles'] }}
=======
   ,"{{ user_name }}_user": {
        "keystone": [
            "user_present",
            {
                "name": "{{ user_name }}"
            },
            {
                "password": "{{ pillar['keystone']['tenants'][tenant_name]['users'][user_name]['password'] }}"
            },
            {
                "email": "{{ pillar['keystone']['tenants'][tenant_name]['users'][user_name]['email'] }}"
            },
            {
                "tenant": "{{ tenant_name }}"
            },
            {
                "roles": [
                    {
                        "{{ tenant_name }}": {{ pillar['keystone']['tenants'][tenant_name]['users'][user_name]['roles'] }}
                    }
                ]
            },
            {
                "require": [
                    {
                        "module": "keystone-user-refresh-repo"
                    }
                ]
            }
        ]
   }
>>>>>>> cd189cab2257ed583018c889d11b66839b1262d7
{% endfor %}
{% endfor %}

