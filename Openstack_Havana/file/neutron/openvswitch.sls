#!jinja|json
{
    "neutron-plugin-openvswitch-agent": {
        "pkg": [
            "installed",
            {
				"require": [
					{
						"module": "create_init_bridges"
					}
				]
            }
        ],
        "service": [
            "running",
            {
                "watch": [
                    {
                        "pkg": "neutron-plugin-openvswitch-agent"
                    },
                    {
                        "ini": "neutron-plugin-openvswitch-agent"
                    },
					{
						"ini": "neutron-conf"
					}
                ]
            }
        ],
        "file": [
            "managed",
            {
                "name": "/etc/neutron/plugins/openvswitch/ovs_neutron_plugin.ini",
                "group": "neutron",
                "user": "neutron",
                "mode": "644",
                "require": [
                    {
                        "pkg": "neutron-plugin-openvswitch-agent"
                    }
                ]
            }
        ],
        "ini": [
			"options_present",
			{
				"name": "/etc/neutron/plugins/openvswitch/ovs_neutron_plugin.ini",
				"sections": {
					"ovs": {
						"integration_bridge": "{{ pillar['neutron']['intergration_bridge'] }}", 
						"tenant_network_type": "{{ pillar['neutron']['network_mode'] }}",
						{% if pillar['neutron']['network_mode'] == 'vlan' %} 
						"enable_tunneling": "False", 
						"network_vlan_ranges": "{{ salt['cluster_ops.get_vlan_ranges']() }}", 
						"bridge_mappings": "{{ salt['cluster_ops.get_bridge_mappings']() }}"
						{% elif pillar['neutron']['network_mode'] == 'tunnel' %}
						"enable_tunneling": "True", 
						"tunnel_id_ranges": "{{ pillar['tunnel_start'] }}:{{ pillar['tunnel_end'] }}",
						"tunnel_type": "{{ pillar['tunnel_type'] }}",
						"local_ip": "{{ pillar['hosts'][grains['id']] }}"
						{% endif %}
					}, 
					"securitygroup": {
						"firewall_driver": "neutron.agent.linux.iptables_firewall.OVSHybridIptablesFirewallDriver"
					}, 
					"database": {
						"connection": "mysql://{{ pillar['mysql']['neutron']['username'] }}:{{ pillar['mysql']['neutron']['password'] }}@{{ salt['cluster_ops.get_candidate']('mysql') }}/neutron"
					}
				}
			},
			{
				"require": [
					{
						"file": "neutron-plugin-openvswitch-agent"
					}
				]
			}
        ]
    },
    "neutron-conf": {
        "file": [
            "managed",
            {
                "name": "/etc/neutron/neutron.conf",
                "group": "neutron",
                "user": "neutron",
                "mode": "644",
                "require": [
                    {
                        "pkg": "neutron-plugin-openvswitch-agent"
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
					"database": {
						"connection": "mysql://{{ pillar['mysql']['neutron']['username'] }}:{{ pillar['mysql']['neutron']['password'] }}@{{ salt['cluster_ops.get_candidate']('mysql') }}/neutron"
					}
				}
			},
			{
				"require": [
					{
						"file": "neutron-conf"
					}
				]
			}
        ]
    },
    "neutron-api-paste-compute": {
        "file": [
            "managed",
            {
                "name": "/etc/neutron/api-paste.ini",
                "group": "neutron",
                "user": "neutron",
                "mode": "644",
                "require": [
                    {
                        "pkg": "neutron-plugin-openvswitch-agent"
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
						"file": "neutron-api-paste-compute"
					}
				]
			}
        ]
    },
    "openvswitch-switch": {
        "pkg": [
            "installed"
        ],
        "service": [
            "running",
            {
                "require": [
                    {
                        "pkg": "openvswitch-switch"
                    }
                ]
            }
        ]
    },
    "openvswitch-datapath-dkms": {
        "pkg": [
            "installed",
            {
                "require": [
                    {
                        "pkg": "openvswitch-switch"
                    }
                ]
            }
        ]
    },
    "create_init_bridges": {
		"module": [
			"run",
			{
				"name": "cluster_ops.create_init_bridges"
			},
			{
				"require": [
					{
						"service": "openvswitch-switch"
					}
				]
			}
		]
    }
}
