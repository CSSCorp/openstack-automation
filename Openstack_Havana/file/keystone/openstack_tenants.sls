#!jinja|json
{
    "keystone-tenant-refresh-repo": {
		"module": [
			"run",
			{
				"name": "saltutil.sync_all"
			},
            {
                "require": [
                    {
						"cmd": "keystone_sync"
                    }
                ]
            }
		]
    }
{% for tenant_name in pillar['keystone']['tenants'] %}
   ,"{{ tenant_name }}_tenant": {
        "keystone": [
            "tenant_present",
            {
                "name": "{{ tenant_name }}"
            },
            {
                "require": [
                    {
						"module": "keystone-tenant-refresh-repo"
                    }
                ]
            }
        ]
   }
{% endfor %}
{% for role_name in pillar['keystone']['roles'] %}
   ,"{{ role_name }}_role": {
        "keystone": [
            "role_present",
            {
                "name": "{{ role_name }}"
            },
            {
                "require": [
                    {
                        "module": "keystone-tenant-refresh-repo"
                    }
                ]
            }
        ]
   }
{% endfor %}
}
