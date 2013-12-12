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
                        "file": "keystone"
                    }
                ]
            }
        ],
        "file": [
            "managed",
            {
                "name": "/etc/keystone/keystone.conf",
                "source": "salt://config/{{ pillar['config-folder'] }}/common/etc/keystone/keystone.conf",
                "require": [
                    {
                        "pkg": "keystone"
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
                        "cmd": "{{ pillar['keystone']['dbname'] }}_sync"
                    }
                ]
            }
        ]
   }
{% for user_name in pillar['keystone']['tenants'][tenant_name]['users'] %}
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
                        "{{ tenant_name }}": [
                            "{{ pillar['keystone']['tenants'][tenant_name]['users'][user_name]['role'] }}"
                        ]
                    }
                ]
            },
            {
                "require": [
                    {
                        "keystone": "{{ tenant_name }}_tenant"
                    },
                    {
                        "keystone": "{{ pillar['keystone']['tenants'][tenant_name]['users'][user_name]['role'] }}_role"
                    }
                ]
            }
        ]
   }
{% endfor %}
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
                        "service": "keystone"
                    }
                ]
            }
        ]
   }
{% endfor %}
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
                        "service": "keystone"
                    }
                ]
            }
        ]
   },
   "{{ service_name }}_endpoint": {
        "keystone": [
            "endpoint_present",
            {
                "service": "{{ service_name }}"
            },
            {
                "publicurl": "{{ pillar['keystone']['services'][service_name]['endpoint']['publicurl'] }}"
            },
            {
                "adminurl": "{{ pillar['keystone']['services'][service_name]['endpoint']['adminurl'] }}"
            },
            {
                "internalurl": "{{ pillar['keystone']['services'][service_name]['endpoint']['internalurl'] }}"
            }
        ]
   }
{% endfor %}
}
