#!jinja|json
{
    "keystone": {
        "pkg": [
            "installed",
            {
                "require": [
                    {
                        "mysql_grants": "{{ grains['id'] }}-keystone-accounts"
                    }
                ]
            }
        ],
        "service": [
            "running",
            {
                "watch": [
                    {
                        "pkg": "keystone"
                    },
                    {
                        "ini": "keystone"
                    }
                ]
            }
        ],
        "file": [
            "managed",
            {
                "name": "/etc/keystone/keystone.conf",
                "user": "root",
                "group": "root",
                "mode": "644",
                "require": [
                    {
                        "pkg": "keystone"
                    }
                ]
            }
        ],
        "ini": [
			"options_present",
			{
				"name": "/etc/keystone/keystone.conf",
				"sections": {
					"DEFAULT": {
						"admin_token": "{{ pillar['keystone']['token'] }}"
					}, 
					"sql": {
						"connection": "mysql://{{ pillar['mysql']['keystone']['username'] }}:{{ pillar['mysql']['keystone']['password'] }}@{{ salt['cluster_ops.get_candidate']('mysql') }}/keystone"
					}
				}
			},
			{
				"require": [
					{
						"file": "keystone"
					}
				]
			}
        ]
    },
    "keystone_sync": {
		"cmd": [
			"run",
			{
				"name": "{{ pillar['mysql']['keystone']['sync'] }}"
			},
			{
				"require": [
					{
						"service": "keystone"
					}
				]
			}
		]
    },
    "keystone_sqlite_delete": {
        "file": [
            "absent",
            {
                "name": "/var/lib/keystone/keystone.sqlite"
            },
            {
                "require": [
                    {
                        "pkg": "keystone"
                    }
                ]
            }
        ]
    }
}
