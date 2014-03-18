#!jinja|json
{
    "glance": {
        "pkg": [
            "installed"
        ],
        "service": [
            "running",
            {
                "names": ["glance-registry", "glance-api"]
            },
            {
                "watch": [
                    {
                        "pkg": "glance"
                    },
                    {
                        "ini": "glance-api-conf"
                    },
                    {
                        "ini": "glance-registry-conf"
                    }
                ]
            }
        ]
    },
    "glance-api-conf": {
        "file": [
            "managed",
            {
                "name": "/etc/glance/glance-api.conf",
                "mode": "644",
                "user": "glance",
                "group": "glance",
                "require": [
                    {
                        "pkg": "glance"
                    }
                ]
            }
        ],
        "ini": [
			"options_present",
			{
				"name": "/etc/glance/glance-api.conf",
				"sections": {
					"DEFAULT": {
						"rabbit_notification_topic": "glance_notifications", 
						"verbose": "True", 
						"qpid_host": "{{ salt['cluster_ops.get_candidate'](pillar['queue-engine']) }}", 
						"sql_connection": "mysql://{{ pillar['mysql']['glance']['username'] }}:{{ pillar['mysql']['glance']['password'] }}@{{ salt['cluster_ops.get_candidate']('mysql') }}/glance", 
						"workers": "0", 
						"use_syslog": "False", 
						"debug": "False", 
						"qpid_notification_topic": "glance_notifications", 
						"swift_store_auth_address": "{{ salt['cluster_ops.get_candidate']('keystone') }}:35357/v2.0/"
					}, 
					"keystone_authtoken": {
						"admin_tenant_name": "service", 
						"admin_user": "glance", 
						"admin_password": "{{ pillar['keystone']['tenants']['service']['users']['glance']['password'] }}", 
						"auth_host": "{{ salt['cluster_ops.get_candidate']('keystone') }}"
					}
				}
			},
			{
				"require": [
					{
						"file": "glance-api-conf"
					}
				]
			}
        ]
    },
    "glance-registry-conf": {
        "file": [
            "managed",
            {
                "name": "/etc/glance/glance-registry.conf",
                "user": "glance",
                "group": "glance",
                "mode": "644",
                "require": [
                    {
                        "pkg": "glance"
                    }
                ]
            }
        ],
        "ini": [
			"options_present",
			{
				"name": "/etc/glance/glance-registry.conf",
				"sections": {
					"DEFAULT": {
						"debug": "False", 
						"sql_connection": "mysql://{{ pillar['mysql']['glance']['username'] }}:{{ pillar['mysql']['glance']['password'] }}@{{ salt['cluster_ops.get_candidate']('mysql') }}/glance", 
						"verbose": "True", 
						"use_syslog": "False"
					}, 
					"keystone_authtoken": {
						"admin_tenant_name": "service", 
						"admin_user": "glance", 
						"admin_password": "{{ pillar['keystone']['tenants']['service']['users']['glance']['password'] }}", 
						"auth_host": "{{ salt['cluster_ops.get_candidate']('keystone') }}"
					}
				}
			},
			{
				"require": [
					{
						"file": "glance-registry-conf"
					}
				]
			}
        ]
    },
    "glance_sync": {
		"cmd": [
			"run",
			{
				"name": "{{ pillar['mysql']['glance']['sync'] }}"
			},
			{
				"require": [
					{
						"service": "glance"
					}
				]
			}
		]
    },
    "glance_sqlite_delete": {
        "file": [
            "absent",
            {
                "name": "/var/lib/glance/glance.sqlite"
            },
            {
                "require": [
                    {
                        "pkg": "glance"
                    }
                ]
            }
        ]
    }
}
