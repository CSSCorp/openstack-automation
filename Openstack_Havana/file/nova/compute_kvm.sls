#!jinja|json
{
    "nova-compute-kvm": {
        "pkg": [
            "installed"
        ]
    },
    "nova-compute": {
        "pkg": [
            "installed"
        ],
        "service": [
            "running",
            {
                "watch": [
                    {
                        "pkg": "nova-compute"
                    },
                    {
                        "ini": "nova-compute"
                    }
                ]
            }
        ],
        "file": [
            "managed",
            {
                "name": "/etc/nova/nova-compute.conf",
                "user": "nova",
                "group": "nova",
                "mode": "644",
                "require": [
                    {
                        "pkg": "nova-compute"
                    }
                ]
            }
        ],
        "ini": [
			"options_present",
			{
				"name": "/etc/nova/nova-compute.conf",
				"sections": {
					"DEFAULT": {
						{% if 'virt.is_hyper' in salt and salt['virt.is_hyper'] %}
						"libvirt_type": "kvm",
						{% else %}
						"libvirt_type": "qemu",
						{% endif %}
						"compute_driver": "libvirt.LibvirtDriver",
						"libvirt_use_virtio_for_bridges": "True", 
						"libvirt_vif_type": "ethernet", 
						"libvirt_ovs_bridge": "br-int", 
						"libvirt_vif_driver": "nova.virt.libvirt.vif.LibvirtGenericVIFDriver"
					}
				}
			},
			{
				"require": [
					{
						"file": "nova-compute"
					}
				]
			}
        ]
    },
    "python-guestfs": {
        "pkg": [
            "installed"
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
                        "pkg": "nova-compute"
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
						"vnc_enabled": "True", 
						"neutron_auth_strategy": "keystone", 
						"neutron_admin_auth_url": "http://{{ salt['cluster_ops.get_candidate']('keystone') }}:35357/v2.0", 
						"rabbit_host": "{{ salt['cluster_ops.get_candidate'](pillar['queue-engine']) }}", 
						"my_ip": "{{ grains['id'] }}", 
						"neutron_admin_username": "neutron", 
						"neutron_admin_tenant_name": "service", 
						"security_group_api": "neutron", 
						"vncserver_listen": "0.0.0.0", 
						"neutron_admin_password": "{{ pillar['keystone']['tenants']['service']['users']['neutron']['password'] }}", 
						"glance_host": "{{ salt['cluster_ops.get_candidate']('glance') }}", 
						"firewall_driver": "nova.virt.firewall.NoopFirewallDriver", 
						"network_api_class": "nova.network.neutronv2.api.API", 
						"vncserver_proxyclient_address": "{{ grains['id'] }}", 
						"rpc_backend": "nova.rpc.impl_kombu", 
						"neutron_url": "http://{{ salt['cluster_ops.get_candidate']('neutron') }}:9696", 
						"novncproxy_base_url": "http://{{ salt['cluster_ops.get_candidate']('nova') }}:6080/vnc_auto.html", 
						"auth_strategy": "keystone"
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
                        "pkg": "nova-compute"
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
