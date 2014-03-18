#!jinja|json
{
    "neutron-server": {
        "pkg": [
            "installed"
        ],
        "service": [
            "running",
            {
                "watch": [
                    {
                        "pkg": "neutron-server"
                    },
                    {
                        "ini": "neutron-server"
                    },
                    {
                        "ini": "neutron-api-paste"
                    }
                ]
            }
        ],
        "file": [
            "managed",
            {
                "name": "/etc/neutron/neutron.conf",
                "user": "neutron",
                "group": "neutron",
                "mode": "644",
                "require": [
                    {
                        "pkg": "neutron-server"
                    }
                ]
            }
        ],
        "ini": [
			"options_present",
			{
				"name": "/etc/neutron/neutron.conf",
				"sections": {
					"DEFAULT": {
						"rabbit_host": "{{ salt['cluster_ops.get_candidate'](pillar['queue-engine']) }}", 
						"neutron_metadata_proxy_shared_secret": "{{ pillar['neutron']['metadata_secret'] }}", 
						"service_neutron_metadata_proxy": "true", 
						"auth_strategy": "keystone", 
						"rpc_backend": "neutron.openstack.common.rpc.impl_kombu"
					}, 
					"keystone_authtoken": {
						"admin_tenant_name": "service", 
						"admin_user": "neutron", 
						"auth_url": "http://{{ salt['cluster_ops.get_candidate']('keystone') }}:35357/v2.0", 
						"admin_password": "{{ pillar['keystone']['tenants']['service']['users']['neutron']['password'] }}", 
						"auth_host": "{{ salt['cluster_ops.get_candidate']('keystone') }}"
					}, 
					"service_providers": {
						"service_provider": "LOADBALANCER:Haproxy:neutron.services.loadbalancer.driver"
					}, 
					"database": {
						"connection": "mysql://{{ pillar['mysql']['neutron']['username'] }}:{{ pillar['mysql']['neutron']['password'] }}@{{ salt['cluster_ops.get_candidate']('mysql') }}/neutron"
					}
				}
			},
			{
				"require": [
					{
						"file": "neutron-server"
					}
				]
			}
        ]
    },
    "neutron-api-paste": {
        "file": [
            "managed",
            {
                "name": "/etc/neutron/api-paste.ini",
                "user": "neutron",
                "group": "neutron",
                "mode": "644",
                "require": [
                    {
                        "pkg": "neutron-server"
                    }
                ]
            }
        ],
        "ini": [
			"options_present",
			{
				"name": "/etc/neutron/api-paste.ini",
				"sections": {
					"filter:authtoken": {
						"admin_tenant_name": "service", 
						"auth_uri": "http://{{ salt['cluster_ops.get_candidate']('keystone') }}:35357/v2.0", 
						"admin_user": "neutron", 
						"admin_password": "{{ pillar['keystone']['tenants']['service']['users']['neutron']['password'] }}", 
						"auth_host": "{{ salt['cluster_ops.get_candidate']('keystone') }}"
					}
				}
			},
			{
				"require": [
					{
						"file": "neutron-api-paste"
					}
				]
			}
        ]
    },
    "neutron-dhcp-agent": {
        "pkg": [
            "installed"
        ],
        "service": [
            "running",
            {
                "require": [
                    {
                        "pkg": "neutron-dhcp-agent"
                    },
                    {
                        "ini": "neutron-dhcp-agent"
                    }
                ]
            }
        ],
        "file": [
            "managed",
            {
                "name": "/etc/neutron/dhcp_agent.ini",
                "user": "neutron",
                "group": "neutron",
                "mode": "644",
                "require": [
                    {
                        "pkg": "neutron-dhcp-agent"
                    }
                ]
            }
        ],
        "ini": [
			"options_present",
			{
				"name": "/etc/neutron/dhcp_agent.ini",
				"sections": {
					"DEFAULT": {
						"dhcp_driver": "neutron.agent.linux.dhcp.Dnsmasq", 
						"interface_driver": "neutron.agent.linux.interface.OVSInterfaceDriver", 
						"use_namespaces": "True"
					}
				}
			},
			{
				"require": [
					{
						"file": "neutron-dhcp-agent"
					}
				]
			}
        ]
    },
    "neutron-metadata-agent": {
        "pkg": [
            "installed"
        ],
        "service": [
            "running",
            {
                "require": [
                    {
                        "pkg": "neutron-metadata-agent"
                    },
                    {
                        "ini": "neutron-metadata-agent"
                    }
                ]
            }
        ],
        "file": [
            "managed",
            {
                "name": "/etc/neutron/metadata_agent.ini",
                "user": "neutron",
                "group": "neutron",
                "mode": "644",
                "require": [
                    {
                        "pkg": "neutron-metadata-agent"
                    }
                ]
            }
        ],
        "ini": [
			"options_present",
			{
				"name": "/etc/neutron/metadata_agent.ini",
				"sections": {
					"DEFAULT": {
						"admin_tenant_name": "service", 
						"admin_user": "neutron", 
						"auth_url": "http://{{ salt['cluster_ops.get_candidate']('keystone') }}:35357/v2.0", 
						"admin_password": "{{ pillar['keystone']['tenants']['service']['users']['neutron']['password'] }}", 
						"metadata_proxy_shared_secret": "{{ pillar['neutron']['metadata_secret'] }}", 
						"nova_metadata_ip": "{{ salt['cluster_ops.get_candidate']('nova-api') }}"
					}
				}
			},
			{
				"require": [
					{
						"file": "neutron-metadata-agent"
					}
				]
			}
        ]
    },
    "neutron-l3-agent": {
        "pkg": [
            "installed"
        ],
        "service": [
            "running",
            {
                "require": [
                    {
                        "pkg": "neutron-l3-agent"
                    },
                    {
                        "ini": "neutron-l3-agent"
                    }
                ]
            }
        ],
        "file": [
            "managed",
            {
                "name": "/etc/neutron/l3_agent.ini",
                "user": "neutron",
                "group": "neutron",
                "mode": "644",
                "require": [
                    {
                        "pkg": "neutron-l3-agent"
                    }
                ]
            }
        ],
        "ini": [
			"options_present",
			{
				"name": "/etc/neutron/l3_agent.ini",
				"sections": {
					"DEFAULT": {
						"interface_driver": "neutron.agent.linux.interface.OVSInterfaceDriver", 
						"use_namespaces": "True", 
						"metadata_ip": "{{ salt['cluster_ops.get_candidate']('neutron') }}"
					}
				}
			},
			{
				"require": [
					{
						"file": "neutron-l3-agent"
					}
				]
			}
        ]
    },
    "enable_forwarding": {
        "file": [
            "managed",
            {
                "name": "/etc/sysctl.conf"
            }
        ],
        "ini": [
			"options_present",
			{
				"name": "/etc/sysctl.conf",
				"sections": {
					"DEFAULT_IMPLICIT": {
						"net.ipv4.conf.all.rp_filter": "0", 
						"net.ipv4.ip_forward": "1", 
						"net.ipv4.conf.default.rp_filter": "0"
					}
				}
			}
        ]
    },
    "networking-service": {
        "service": [
            "running",
            {
                "name": "networking"
            },
            {
                "watch": [
                    {
                        "file": "enable_forwarding"
                    }
                ]
            }
        ]
    }
}
