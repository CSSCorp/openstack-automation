<<<<<<< HEAD
neutron-dhcp-agent: 
  pkg: 
    - installed
  service: 
    - running
    - watch: 
      - pkg: neutron-dhcp-agent
      - ini: neutron-dhcp-agent
  file: 
    - managed
    - name: /etc/neutron/dhcp_agent.ini
    - user: neutron
    - group: neutron
    - mode: 644
    - require: 
      - pkg: neutron-dhcp-agent
  ini: 
    - options_present
    - name: /etc/neutron/dhcp_agent.ini
    - sections: 
        DEFAULT: 
          dhcp_driver: neutron.agent.linux.dhcp.Dnsmasq
          interface_driver: neutron.agent.linux.interface.OVSInterfaceDriver
          use_namespaces: True
    - require: 
      - file: neutron-dhcp-agent
neutron-metadata-agent: 
  pkg: 
    - installed
  service: 
    - running
    - watch: 
      - pkg: neutron-metadata-agent
      - ini: neutron-metadata-agent
  file: 
    - managed
    - name: /etc/neutron/metadata_agent.ini
    - user: neutron
    - group: neutron
    - mode: 644
    - require: 
      - pkg: neutron-metadata-agent
  ini: 
    - options_present
    - name: /etc/neutron/metadata_agent.ini
    - sections: 
        DEFAULT: 
          admin_tenant_name: service
          auth_region: RegionOne
          admin_user: neutron
          auth_url: http://{{ salt['cluster_ops.get_candidate']('keystone') }}:5000/v2.0
          admin_password: {{ pillar['keystone']['tenants']['service']['users']['neutron']['password'] }}
          metadata_proxy_shared_secret: {{ pillar['neutron']['metadata_secret'] }}
          nova_metadata_ip: {{ salt['cluster_ops.get_candidate']('nova') }}
    - require: 
      - file: neutron-metadata-agent
neutron-l3-agent: 
  pkg: 
    - installed
  service: 
    - running
    - watch: 
      - pkg: neutron-l3-agent
      - ini: neutron-l3-agent
  file: 
    - managed
    - name: /etc/neutron/l3_agent.ini
    - user: neutron
    - group: neutron
    - mode: 644
    - require: 
      - pkg: neutron-l3-agent
  ini: 
    - options_present
    - name: /etc/neutron/l3_agent.ini
    - sections: 
        DEFAULT: 
          interface_driver: neutron.agent.linux.interface.OVSInterfaceDriver
          use_namespaces: True
    - require: 
      - file: neutron-l3-agent
enable_forwarding: 
  file: 
    - managed
    - name: /etc/sysctl.conf
  ini: 
    - options_present
    - name: /etc/sysctl.conf
    - sections: 
        DEFAULT_IMPLICIT: 
          net.ipv4.conf.all.rp_filter: 0
          net.ipv4.ip_forward: 1
          net.ipv4.conf.default.rp_filter: 0
networking-service: 
  service: 
    - running
    - name: networking
    - watch: 
      - file: enable_forwarding
neutron-service-conf: 
  ini: 
    - options_present
    - name: /etc/neutron/neutron.conf
    - sections: 
        DEFAULT: 
          rabbit_host: {{ salt['cluster_ops.get_candidate']('queue.' + pillar['queue-engine']) }}
          auth_strategy: keystone
          rpc_backend: neutron.openstack.common.rpc.impl_kombu
          core_plugin: ml2
          service_plugins: router
          allow_overlapping_ips: True
          verbose: True
        keystone_authtoken: 
          auth_protocol: http
          admin_user: neutron
          admin_password: {{ pillar['keystone']['tenants']['service']['users']['neutron']['password'] }}
          auth_host: {{ salt['cluster_ops.get_candidate']('keystone') }}
          auth_uri: http://{{ salt['cluster_ops.get_candidate']('keystone') }}:5000
          admin_tenant_name: service
          auth_port: 35357
=======
#!jinja|json
{
    "neutron-dhcp-agent": {
        "pkg": [
            "installed"
        ],
        "service": [
            "running",
            {
                "watch": [
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
                "watch": [
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
						"auth_region": "RegionOne",
						"admin_user": "neutron", 
						"auth_url": "http://{{ salt['cluster_ops.get_candidate']('keystone') }}:5000/v2.0", 
						"admin_password": "{{ pillar['keystone']['tenants']['service']['users']['neutron']['password'] }}", 
						"metadata_proxy_shared_secret": "{{ pillar['neutron']['metadata_secret'] }}", 
						"nova_metadata_ip": "{{ salt['cluster_ops.get_candidate']('nova') }}"
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
                "watch": [
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
						"use_namespaces": "True"
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
    },
    "neutron-service-conf": {
		"ini": [
			"options_present",
			{
				"name": "/etc/neutron/neutron.conf",
				"sections": {
					"DEFAULT": {
						"rabbit_host": "{{ salt['cluster_ops.get_candidate']('queue.' + pillar['queue-engine']) }}", 
						"auth_strategy": "keystone", 
						"rpc_backend": "neutron.openstack.common.rpc.impl_kombu",
						"core_plugin": "ml2",
						"service_plugins": "router",
						"allow_overlapping_ips": "True",
						"verbose": "True"
					}, 
					"keystone_authtoken": {
						"auth_protocol": "http", 
						"admin_user": "neutron", 
						"admin_password": "{{ pillar['keystone']['tenants']['service']['users']['neutron']['password'] }}", 
						"auth_host": "{{ salt['cluster_ops.get_candidate']('keystone') }}", 
						"auth_uri": "http://{{ salt['cluster_ops.get_candidate']('keystone') }}:5000",
						"admin_tenant_name": "service", 
						"auth_port": "35357"
					}
				}
			}
		]
    }
}
>>>>>>> cd189cab2257ed583018c889d11b66839b1262d7
