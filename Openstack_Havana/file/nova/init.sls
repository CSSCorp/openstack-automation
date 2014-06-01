<<<<<<< HEAD
nova-api:
  pkg:
    - installed
  service
    - running
    - watch
      - ini: nova-conf
nova-conductor:
  pkg:
    - installed
  service:
    - running
    - watch
      - ini: nova-conf
nova-scheduler:
  pkg:
    - installed
  service
    - running
    - watch:
      - ini: nova-conf
nova-cert:
  pkg:
    - installed
  service:
    - running
    - watch:
      - ini: nova-conf
nova-consoleauth:
  pkg:
    - installed
  service:
    - running
    - watch:
      - ini: nova-conf
python-novaclient:
  pkg:
    - installed
nova-ajax-console-proxy:
  pkg:
    - installed
novnc:
  pkg:
    - installed
nova-novncproxy:
  pkg:
    - installed
  service:
    - running
    - watch:
      - ini: nova-conf
nova_sync:
  cmd:
    - run
    - name: {{ pillar['services']['nova']['db_sync'] }}
    - require:
      - service: nova-api
nova_sqlite_delete:
  file:
    - absent
    - name: /var/lib/nova/nova.sqlite
    - require:
      - pkg: nova-api
nova-conf:
  file:
    - managed
    - user: nova
    - group: nova
    - mode: 644
    - require:
      - pkg: nova-api
  ini:
    - options_present
    - name: /etc/nova/nova.conf
    - sections: 
	      DEFAULT: 
	        auth_strategy: "keystone"
	        rabbit_host: "{{ salt['cluster_ops.get_candidate']('queue.' + pillar['queue-engine']) }}"
	        my_ip: "{{ grains['id'] }}"
	        vncserver_listen: "{{ salt['cluster_ops.get_candidate']('nova') }}"
	        vncserver_proxyclient_address: "{{ salt['cluster_ops.get_candidate']('nova') }}"
	        rpc_backend: "{{ pillar['queue-engine'] }}"
	        network_api_class: "nova.network.neutronv2.api.API"
	        neutron_url: "http://{{ salt['cluster_ops.get_candidate']('neutron') }}:9696"
	        neutron_auth_strategy: "keystone"
	        neutron_admin_tenant_name: "service"
	        neutron_admin_username: "neutron"
	        neutron_admin_password: "{{ pillar['keystone']['tenants']['service']['users']['neutron']['password'] }}"
	        neutron_admin_auth_url: "http://{{ salt['cluster_ops.get_candidate']('keystone') }}:35357/v2.0"
	        linuxnet_interface_driver: "nova.network.linux_net.LinuxOVSInterfaceDriver"
	        firewall_driver: "nova.virt.firewall.NoopFirewallDriver"
	        security_group_api: "neutron"
	        service_neutron_metadata_proxy: "True"
	        neutron_metadata_proxy_shared_secret: "{{ pillar['neutron']['metadata_secret'] }}"
	        vif_plugging_is_fatal: "False"
	        vif_plugging_timeout: "0"
	      keystone_authtoken: 
	        auth_protocol: "http"
	        admin_user: "nova"
	        admin_password: "{{ pillar['keystone']['tenants']['service']['users']['nova']['password'] }}"
	        auth_host: "{{ salt['cluster_ops.get_candidate']('keystone') }}"
	        auth_uri: "http://{{ salt['cluster_ops.get_candidate']('keystone') }}:5000"
	        admin_tenant_name: "service"
	        auth_port: "35357"
	      database: 
	        connection: "mysql://{{ pillar['mysql'][pillar['services']['nova']['db_name']]['username'] }}:{{ pillar['mysql'][pillar['services']['nova']['db_name']]['password'] }}@{{ salt['cluster_ops.get_candidate']('mysql') }}/{{ pillar['services']['nova']['db_name'] }}"
    - require:
      -file: nova-conf
=======
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
                    }
                ]
            }
        ]
    },
    "nova_sync": {
		"cmd": [
			"run",
			{
				"name": "{{ pillar['services']['nova']['db_sync'] }}"
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
						"auth_strategy": "keystone",
						"rabbit_host": "{{ salt['cluster_ops.get_candidate']('queue.' + pillar['queue-engine']) }}", 
						"my_ip": "{{ grains['id'] }}", 
						"vncserver_listen": "{{ salt['cluster_ops.get_candidate']('nova') }}", 
						"vncserver_proxyclient_address": "{{ salt['cluster_ops.get_candidate']('nova') }}", 
						"rpc_backend": "{{ pillar['queue-engine'] }}",
						"network_api_class": "nova.network.neutronv2.api.API",
						"neutron_url": "http://{{ salt['cluster_ops.get_candidate']('neutron') }}:9696",
						"neutron_auth_strategy": "keystone",
						"neutron_admin_tenant_name": "service",
						"neutron_admin_username": "neutron",
						"neutron_admin_password": "{{ pillar['keystone']['tenants']['service']['users']['neutron']['password'] }}",
						"neutron_admin_auth_url": "http://{{ salt['cluster_ops.get_candidate']('keystone') }}:35357/v2.0",
						"linuxnet_interface_driver": "nova.network.linux_net.LinuxOVSInterfaceDriver",
						"firewall_driver": "nova.virt.firewall.NoopFirewallDriver",
						"security_group_api": "neutron",
						"service_neutron_metadata_proxy": "True",
						"neutron_metadata_proxy_shared_secret": "{{ pillar['neutron']['metadata_secret'] }}",
						"vif_plugging_is_fatal": "False",
						"vif_plugging_timeout": "0"
					}, 
					"keystone_authtoken": {
						"auth_protocol": "http", 
						"admin_user": "nova", 
						"admin_password": "{{ pillar['keystone']['tenants']['service']['users']['nova']['password'] }}", 
						"auth_host": "{{ salt['cluster_ops.get_candidate']('keystone') }}", 
						"auth_uri": "http://{{ salt['cluster_ops.get_candidate']('keystone') }}:5000",
						"admin_tenant_name": "service", 
						"auth_port": "35357"
					}, 
					"database": {
						"connection": "mysql://{{ pillar['mysql'][pillar['services']['nova']['db_name']]['username'] }}:{{ pillar['mysql'][pillar['services']['nova']['db_name']]['password'] }}@{{ salt['cluster_ops.get_candidate']('mysql') }}/{{ pillar['services']['nova']['db_name'] }}"
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
    }
}
>>>>>>> cd189cab2257ed583018c889d11b66839b1262d7
