#!jinja|json
{
    "nova-api": {
        "pkg": [
            "installed"
        ],
        "service": [
            "running",
            {
                "watch": [
                    {
                        "ini": "nova-conf"
                    },
                    {
                        "ini": "nova-api-paste"
                    }
                ]
            }
        ]
    },
    "nova-conductor": {
        "pkg": [
            "installed"
        ],
        "service": [
            "running",
            {
                "watch": [
                    {
                        "ini": "nova-conf"
                    },
                    {
                        "ini": "nova-api-paste"
                    }
                ]
            }
        ]
    },
    "nova-scheduler": {
        "pkg": [
            "installed"
        ],
        "service": [
            "running",
            {
                "watch": [
                    {
                        "ini": "nova-conf"
                    },
                    {
                        "ini": "nova-api-paste"
                    }
                ]
            }
        ]
    },
    "nova-cert": {
        "pkg": [
            "installed"
        ],
        "service": [
            "running",
            {
                "watch": [
                    {
                        "ini": "nova-conf"
                    },
                    {
                        "ini": "nova-api-paste"
                    }
                ]
            }
        ]
    },
    "nova-consoleauth": {
        "pkg": [
            "installed"
        ],
        "service": [
            "running",
            {
                "watch": [
                    {
                        "ini": "nova-conf"
                    },
                    {
                        "ini": "nova-api-paste"
                    }
                ]
            }
        ]
    },
    "nova-doc": {
        "pkg": [
            "installed"
        ]
    },
    "python-novaclient": {
        "pkg": [
            "installed"
        ]
    },
    "nova-ajax-console-proxy": {
        "pkg": [
            "installed"
        ]
    },
    "novnc": {
        "pkg": [
            "installed"
        ]
    },
    "nova-novncproxy": {
        "pkg": [
            "installed"
        ],
        "service": [
            "running",
            {
                "watch": [
                    {
                        "ini": "nova-conf"
                    },
                    {
                        "ini": "nova-api-paste"
                    }
                ]
            }
        ]
    },
    "nova_sync": {
		"cmd": [
			"run",
			{
				"name": "{{ pillar['mysql']['nova']['sync'] }}"
			},
			{
				"require": [
					{
						"service": "nova-api"
					}
				]
			}
		]
    },
    "nova_sqlite_delete": {
        "file": [
            "absent",
            {
                "name": "/var/lib/nova/nova.sqlite"
            },
            {
                "require": [
                    {
                        "pkg": "nova-api"
                    }
                ]
            }
        ]
    },
    "nova-conf": {
        "file": [
            "managed",
            {
                "name": "/etc/nova/nova.conf",
                "user": "nova",
                "password": "nova",
                "mode": "644",
                "require": [
                    {
                        "pkg": "nova-api"
                    }
                ]
            }
        ],
        "ini": [
			"options_present",
			{
				"name": "/etc/nova/nova.conf",
				"sections": {
					"DEFAULT": {
						"firewall_driver": "nova.virt.firewall.NoopFirewallDriver", 
						"region_list": "['RegionOne']", 
						"ec2_dmz_host": "{{ salt['cluster_ops.get_candidate']('nova') }}", 
						"neutron_admin_username": "neutron", 
						"service_neutron_metadata_proxy": "true", 
						"neutron_auth_strategy": "keystone", 
						"rabbit_host": "{{ salt['cluster_ops.get_candidate'](pillar['queue-engine']) }}", 
						"my_ip": "{{ grains['id'] }}", 
						"lockout_attempts": "5", 
						"vncserver_listen": "{{ salt['cluster_ops.get_candidate']('nova') }}", 
						"ec2_host": "{{ salt['cluster_ops.get_candidate']('nova') }}", 
						"neutron_admin_auth_url": "http://{{ salt['cluster_ops.get_candidate']('keystone') }}:35357/v2.0", 
						"ec2_path": "/services/Cloud", 
						"neutron_url": "http://{{ salt['cluster_ops.get_candidate']('neutron') }}:9696", 
						"keystone_ec2_url": "http://{{ salt['cluster_ops.get_candidate']('nova') }}:5000/v2.0/ec2tokens", 
						"auth_strategy": "keystone", 
						"ec2_timestamp_expiry": "300", 
						"network_api_class": "nova.network.neutronv2.api.API", 
						"ec2_port": "8773", 
						"neutron_metadata_proxy_shared_secret": "{{ pillar['neutron']['metadata_secret'] }}", 
						"lockout_minutes": "15", 
						"ec2_strict_validation": "True", 
						"neutron_admin_password": "{{ pillar['keystone']['tenants']['service']['users']['neutron']['password'] }}", 
						"ec2_listen_port": "8773", 
						"ec2_listen": "0.0.0.0", 
						"lockout_window": "15", 
						"neutron_admin_tenant_name": "service", 
						"security_group_api": "neutron", 
						"ec2_sheme": "http", 
						"vncserver_proxyclient_address": "{{ salt['cluster_ops.get_candidate']('nova') }}", 
						"rpc_backend": "nova.rpc.impl_kombu"
					}, 
					"keystone_authtoken": {
						"auth_protocol": "http", 
						"admin_user": "nova", 
						"admin_password": "{{ pillar['keystone']['tenants']['service']['users']['nova']['password'] }}", 
						"auth_host": "{{ salt['cluster_ops.get_candidate']('keystone') }}", 
						"admin_tenant_name": "service", 
						"auth_port": "35357"
					}, 
					"database": {
						"connection": "mysql://{{ pillar['mysql']['nova']['username'] }}:{{ pillar['mysql']['nova']['password'] }}@{{ salt['cluster_ops.get_candidate']('mysql') }}/nova"
					}
				}
			},
			{
				"require": [
					{
						"file": "nova-conf"
					}
				]
			}
        ]
    },
    "nova-api-paste": {
        "file": [
            "managed",
            {
                "name": "/etc/nova/api-paste.ini",
                "user": "nova",
                "group": "nova",
                "mode": "644",
                "require": [
                    {
                        "pkg": "nova-api"
                    }
                ]
            }
        ],
        "ini": [
			"options_present",
			{
				"name": "/etc/nova/api-paste.ini",
				"sections": {
					"filter:authtoken": {
						"auth_protocol": "http", 
						"admin_user": "nova", 
						"admin_password": "{{ pillar['keystone']['tenants']['service']['users']['nova']['password'] }}", 
						"auth_host": "{{ salt['cluster_ops.get_candidate']('keystone') }}", 
						"admin_tenant_name": "service", 
						"auth_port": "35357"
					}, 
					"composite:ec2": {
						"/services/Admin": "ec2cloud"
					}
				}
			},
			{
				"require": [
					{
						"file": "nova-api-paste"
					}
				]
			}
        ]
    }
}
