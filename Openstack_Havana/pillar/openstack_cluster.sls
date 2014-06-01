<<<<<<< HEAD
  cluster_entities: 
    - "compute"
    - "controller"
    - "network"
  compute: 
    - "mars"
    - "pluto"
  controller: 
    - "sun"
  network: 
    - "sun"
  cluster_name: "openstack_cluster"
  keystone.auth_url: "http://sun:5000/v2.0/"
  keystone.endpoint: "http://sun:35357/v2.0"
  keystone.token: "24811ee3d9a09915bef0"
  keystone.user: "admin"
  keystone.password: "admin_pass"
  keystone.tenant: "admin"
  cluster_type: "openstack"
  pkg_proxy_url: "http://mars:3142"
  queue-engine: "rabbit"
  mysql: 
    nova: 
      username: "nova"
      password: "nova_pass"
      service: "nova-api"
    dash: 
      username: "dash"
      password: "dash_pass"
    keystone: 
      username: "keystone"
      password: "keystone_pass"
      service: "keystone"
    cinder: 
      username: "cinder"
      password: "cinder_pass"
    glance: 
      username: "glance"
      password: "glance_pass"
      service: "glance"
    neutron: 
      username: "neutron"
      password: "neutron_pass"
  keystone: 
    endpoint: "http://sun:35357/v2.0"
    token: "24811ee3d9a09915bef0"
    roles: 
      - "admin"
      - "Member"
    services: 
      glance: 
        service_type: "image"
        endpoint: 
          adminurl: "http://{{ grains['id'] }}:9292"
          internalurl: "http://{{ grains['id'] }}:9292"
          publicurl: "http://{{ grains['id'] }}:9292"
        description: "glance image service"
      keystone: 
        service_type: "identity"
        endpoint: 
          adminurl: "http://{{ grains['id'] }}:35357/v2.0"
          internalurl: "http://{{ grains['id'] }}:5000/v2.0"
          publicurl: "http://{{ grains['id'] }}:5000/v2.0"
        description: "Openstack Identity"
      neutron: 
        service_type: "network"
        endpoint: 
          adminurl: "http://{{ grains['id'] }}:9696"
          internalurl: "http://{{ grains['id'] }}:9696"
          publicurl: "http://{{ grains['id'] }}:9696"
        description: "Openstack network service"
      nova: 
        service_type: "compute"
        endpoint: 
          adminurl: "http://{{ grains['id'] }}:8774/v2/%(tenant_id)s"
          internalurl: "http://{{ grains['id'] }}:8774/v2/%(tenant_id)s"
          publicurl: "http://{{ grains['id'] }}:8774/v2/%(tenant_id)s"
        description: "nova compute service"
    tenants: 
      admin: 
        users: 
          admin: 
            password: "admin_pass"
            roles: "[\"admin\", \"_member_\"]"
            email: "salt@csscorp.com"
      service: 
        users: 
          cinder: 
            password: "cinder_pass"
            roles: "[\"admin\"]"
            email: "salt@csscorp.com"
          glance: 
            password: "glance_pass"
            roles: "[\"admin\"]"
            email: "salt@csscorp.com"
          neutron: 
            password: "neutron_pass"
            roles: "[\"admin\"]"
            email: "salt@csscorp.com"
          nova: 
            password: "nova_pass"
            roles: "[\"admin\"]"
            email: "salt@csscorp.com"
    dbname: "keystone"
  neutron: 
    metadata_secret: "414c66b22b1e7a20cc35"
    tenant_network_types: 
      - "vlan"
      - "flat"
    tunnel_start: "1"
    tunnel_end: "1000"
    type_drivers: 
      flat: 
        sun: 
          External: 
            bridge: "br-ex"
            interface: "eth3"
      vlan: 
        pluto: 
          Intnet1: 
            vlan_range: 
              - "100"
              - "200"
            bridge: "br-eth1"
            interface: "eth1"
        mars: 
          Intnet1: 
            vlan_range: 
              - "100"
              - "200"
            bridge: "br-eth1"
            interface: "eth1"
        sun: 
          Intnet1: 
            vlan_range: 
              - "100"
              - "200"
            bridge: "br-eth1"
            interface: "eth1"
  install: 
    controller: 
      - "generics.apt-proxy"
      - "generics.headers"
      - "generics.host"
      - "mysql"
      - "mysql.client"
      - "mysql.openstack_dbschema"
      - "queue.rabbit"
      - "keystone"
      - "keystone.openstack_tenants"
      - "keystone.openstack_users"
      - "keystone.openstack_services"
      - "glance"
      - "nova"
      - "neutron"
      - "neutron.ml2"
      - "horizon"
    network: 
      - "generics.apt-proxy"
      - "generics.headers"
      - "generics.host"
      - "mysql.client"
      - "neutron.service"
      - "neutron.ml2"
      - "neutron.openvswitch"
    compute: 
      - "generics.apt-proxy"
      - "generics.headers"
      - "generics.host"
      - "mysql.client"
      - "nova.compute_kvm"
      - "neutron.openvswitch"
      - "neutron.ml2"
  hosts: 
    sun: "10.8.127.54"
    mars: "10.8.127.51"
    salt: "10.8.27.28"
    pluto: "10.8.127.52"
  services: 
    keystone: 
      db_name: "keystone"
      db_sync: "keystone-manage db_sync"
    glance: 
      db_sync: "glance-manage db_sync"
      db_name: "glance"
    nova: 
      db_name: "nova"
      db_sync: "nova-manage db sync"
    neutron: 
      db_name: "neutron"

=======
#!jinja|json
{
	"cluster_entities": [
		"compute",
		"controller",
		"network"
	],
    "compute": [
        "mars",
        "pluto"
    ],
    "controller": [
        "sun"
    ], 
    "network": [
		"sun"
    ],
    "cluster_name": "openstack_cluster",
    "keystone.auth_url": "http://sun:5000/v2.0/", 
    "keystone.endpoint": "http://sun:35357/v2.0", 
    "keystone.token": "24811ee3d9a09915bef0",
    "keystone.user": "admin",
    "keystone.password": "admin_pass",
    "keystone.tenant": "admin",
    "cluster_type": "openstack", 
    "pkg_proxy_url": "http://mars:3142",
    "queue-engine": "rabbit",
    "mysql": {
        "nova": {
            "username": "nova", 
            "password": "nova_pass", 
            "service": "nova-api"
        }, 
        "dash": {
            "username": "dash", 
            "password": "dash_pass"
        }, 
        "keystone": {
            "username": "keystone", 
            "password": "keystone_pass", 
            "service": "keystone"
        }, 
        "cinder": {
            "username": "cinder", 
            "password": "cinder_pass"
        }, 
        "glance": {
            "username": "glance", 
            "password": "glance_pass", 
            "service": "glance"
        }, 
        "neutron": {
            "username": "neutron", 
            "password": "neutron_pass"
        }
    }, 
    "keystone": {
        "endpoint": "http://sun:35357/v2.0", 
        "token": "24811ee3d9a09915bef0", 
        "roles": [
            "admin", 
            "Member"
        ], 
        "services": { 
            "glance": {
                "service_type": "image", 
                "endpoint": {
                    "adminurl": "http://{{ grains['id'] }}:9292", 
                    "internalurl": "http://{{ grains['id'] }}:9292", 
                    "publicurl": "http://{{ grains['id'] }}:9292"
                }, 
                "description": "glance image service"
            }, 
            "keystone": {
                "service_type": "identity", 
                "endpoint": {
                    "adminurl": "http://{{ grains['id'] }}:35357/v2.0", 
                    "internalurl": "http://{{ grains['id'] }}:5000/v2.0", 
                    "publicurl": "http://{{ grains['id'] }}:5000/v2.0"
                }, 
                "description": "Openstack Identity"
            }, 
            "neutron": {
                "service_type": "network", 
                "endpoint": {
                    "adminurl": "http://{{ grains['id'] }}:9696", 
                    "internalurl": "http://{{ grains['id'] }}:9696", 
                    "publicurl": "http://{{ grains['id'] }}:9696"
                }, 
                "description": "Openstack network service"
            }, 
            "nova": {
                "service_type": "compute", 
                "endpoint": {
                    "adminurl": "http://{{ grains['id'] }}:8774/v2/%(tenant_id)s", 
                    "internalurl": "http://{{ grains['id'] }}:8774/v2/%(tenant_id)s", 
                    "publicurl": "http://{{ grains['id'] }}:8774/v2/%(tenant_id)s"
                }, 
                "description": "nova compute service"
            }
        }, 
        "tenants": {
            "admin": {
                "users": {
                    "admin": {
                        "password": "admin_pass", 
                        "roles": "[\"admin\", \"_member_\"]", 
                        "email": "salt@csscorp.com"
                    }
                }
            }, 
            "service": {
                "users": {
                    "cinder": {
                        "password": "cinder_pass", 
                        "roles": "[\"admin\"]", 
                        "email": "salt@csscorp.com"
                    }, 
                    "glance": {
                        "password": "glance_pass", 
                        "roles": "[\"admin\"]", 
                        "email": "salt@csscorp.com"
                    }, 
                    "neutron": {
                        "password": "neutron_pass", 
                        "roles": "[\"admin\"]", 
                        "email": "salt@csscorp.com"
                    }, 
                    "nova": {
                        "password": "nova_pass", 
                        "roles": "[\"admin\"]", 
                        "email": "salt@csscorp.com"
                    }
                }
            }
        }, 
        "dbname": "keystone"
    }, 
    "neutron": {
		"metadata_secret": "414c66b22b1e7a20cc35",
		"tenant_network_types": ["vlan", "flat"],
		"tunnel_start": "1",
		"tunnel_end": "1000",
		"type_drivers": {
			"flat": {
				"sun": {
					"External": {
						"bridge": "br-ex",
						"interface": "eth3"
					}
				}
			},
			"vlan": {			
				"pluto": {
					"Intnet1": {
						"vlan_range": ["100", "200"],
						"bridge": "br-eth1",
						"interface": "eth1"
					}
				},
				"mars": {
					"Intnet1": {
						"vlan_range": ["100", "200"],
						"bridge": "br-eth1",
						"interface": "eth1"
					}
				},
				"sun": {
					"Intnet1": {
						"vlan_range": ["100", "200"],
						"bridge": "br-eth1",
						"interface": "eth1"
					}
				}
			}
		}
    },
    "install": {
        "controller": [
            "generics.apt-proxy", 
            "generics.headers",
            "generics.host",
            "mysql",
            "mysql.client",
            "mysql.openstack_dbschema",
            "queue.rabbit",
            "keystone",
            "keystone.openstack_tenants",
            "keystone.openstack_users",
            "keystone.openstack_services",
            "glance",
            "nova",
            "neutron",
            "neutron.ml2",
            "horizon"
        ], 
        "network": [
            "generics.apt-proxy", 
            "generics.headers",
            "generics.host",
            "mysql.client",
            "neutron.service",
            "neutron.ml2",
            "neutron.openvswitch"
        ],
        "compute": [
            "generics.apt-proxy", 
            "generics.headers",
            "generics.host",
            "mysql.client",
            "nova.compute_kvm",
            "neutron.openvswitch",
            "neutron.ml2"
        ]
    },
    "hosts": {
		"sun": "10.8.127.54",
		"mars": "10.8.127.51",
		"salt": "10.8.27.28",
		"pluto": "10.8.127.52"
    },
    "services": {
		"keystone": {
			"db_name": "keystone",
			"db_sync": "keystone-manage db_sync"
		},
		"glance": {
            "db_sync": "glance-manage db_sync", 
			"db_name": "glance"
		},
		"nova": {
			"db_name": "nova", 
            "db_sync": "nova-manage db sync"
		},
		"neutron": {
			"db_name": "neutron"
		}
    }
}
>>>>>>> cd189cab2257ed583018c889d11b66839b1262d7
