#!jinja|json
{
    "keystone-service-refresh-repo": {
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
{% for service_name in pillar['keystone']['services'] %}
   ,"{{ service_name }}_service": {
        "keystone": [
            "service_present",
            {
                "name": "{{ service_name }}"
            },
            {
                "service_type": "{{ pillar['keystone']['services'][service_name]['service_type'] }}"
            },
            {
                "description": "{{ pillar['keystone']['services'][service_name]['description'] }}"
            },
            {
                "require": [
                    {
                        "module": "keystone-service-refresh-repo"
                    }
                ]
            }
        ]
   },
   "{{ service_name }}_endpoint": {
        "keystone": [
            "endpoint_present",
            {
                "name": "{{ service_name }}"
            },
            {
                "publicurl": "{{ pillar['keystone']['services'][service_name]['endpoint']['publicurl'] }}"
            },
            {
                "adminurl": "{{ pillar['keystone']['services'][service_name]['endpoint']['adminurl'] }}"
            },
            {
                "internalurl": "{{ pillar['keystone']['services'][service_name]['endpoint']['internalurl'] }}"
            },
            {
                "require": [
                    {
                        "keystone": "{{ service_name }}_service"
                    }
                ]
            }
        ]
   }
{% endfor %}
}
