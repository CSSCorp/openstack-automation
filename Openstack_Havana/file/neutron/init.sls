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
                        "file": "neutron-api-paste"
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
						"rabbit_host": "{{ salt['cluster_ops.get_candidate']('queue.' + pillar['queue-engine']) }}", 
						"auth_strategy": "keystone", 
						"rpc_backend": "neutron.openstack.common.rpc.impl_kombu",
						"core_plugin": "ml2",
						"service_plugins": "router",
						"allow_overlapping_ips": "True",
						"verbose": "True",
						"notify_nova_on_port_status_changes": "True",
						"notify_nova_on_port_data_changes": "True",
						"nova_url": "http://{{ salt['cluster_ops.get_candidate']('keystone') }}:8774/v2",
						"nova_admin_username": "nova",
						"nova_admin_tenant_id": "service",
						"nova_admin_password": "{{ pillar['keystone']['tenants']['service']['users']['nova']['password'] }}",
						"nova_admin_auth_url": "http://{{ salt['cluster_ops.get_candidate']('keystone') }}:35357/v2.0"
					}, 
					"keystone_authtoken": {
						"auth_protocol": "http", 
						"admin_user": "neutron", 
						"admin_password": "{{ pillar['keystone']['tenants']['service']['users']['neutron']['password'] }}", 
						"auth_host": "{{ salt['cluster_ops.get_candidate']('keystone') }}", 
						"auth_uri": "http://{{ salt['cluster_ops.get_candidate']('keystone') }}:5000",
						"admin_tenant_name": "service", 
						"auth_port": "35357"
					}, 
					"database": {
						"connection": "mysql://{{ pillar['mysql'][pillar['services']['neutron']['db_name']]['username'] }}:{{ pillar['mysql'][pillar['services']['neutron']['db_name']]['password'] }}@{{ salt['cluster_ops.get_candidate']('mysql') }}/{{ pillar['services']['neutron']['db_name'] }}"
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
        ]
    }
}
