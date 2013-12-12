#!jinja|json
{
    "controller": [
        "hawk"
    ],
    "compute": [
        "lammer"
    ],
    "install": {
        "controller": [
            "generics.host",
            "generics.havana",
            "generics.ntp",
            "mysql",
            "queue.rabbit",
            "keystone",
            "glance",
            "nova",
            "mysql.client",
            "horizon",
            "neutron",
            "neutron.openvswitch"
        ],
        "compute": [
            "generics.host",
            "generics.havana",
            "generics.ntp",
            "mysql.client",
            "nova.compute_kvm",
            "neutron.openvswitch"
        ]
    },
    "salt-master": "10.8.27.28",
    "cluster_type": "openstack",
    "config-folder": "cluster1",
    "keystone.token": "24811ee3d9a09915bef0",
    "keystone.endpoint": "http://hawk:35357/v2.0",
    "keystone": {
        "token": "24811ee3d9a09915bef0",
        "endpoint": "http://hawk:35357/v2.0",
        "dbname": "keystone",
        "tenants": {
            "admin": {
                "users": {
                    "admin": {
                        "password": "admin_pass",
                        "email": "salt@csscorp.com",
                        "role": "admin"
                    }
                }
            },
            "service": {
                "users": {
                    "glance": {
                        "password": "glance_pass",
                        "email": "salt@csscorp.com",
                        "role": "admin"
                    },
                    "nova": {
                        "password": "nova_pass",
                        "email": "salt@csscorp.com",
                        "role": "admin"
                    },
                    "cinder": {
                        "password": "cinder_pass",
                        "email": "salt@csscorp.com",
                        "role": "admin"
                    },
                    "neutron": {
                        "password": "neutron_pass",
                        "email": "salt@csscorp.com",
                        "role": "admin"
                    }
                }
            }
        },
        "roles": [
            "admin",
            "Member"
        ],
        "services": {
            "keystone": {
                "service_type": "identity",
                "description": "keystone identity service",
                "endpoint": {
                    "publicurl": "http://{{ grains['id'] }}:5000/v2.0",
                    "internalurl": "http://{{ grains['id'] }}:5000/v2.0",
                    "adminurl": "http://{{ grains['id'] }}:35357/v2.0"
                }
            },
            "glance": {
                "service_type": "image",
                "description": "glance image service",
                "endpoint": {
                    "publicurl": "http://{{ grains['id'] }}:9292",
                    "internalurl": "http://{{ grains['id'] }}:9292",
                    "adminurl": "http://{{ grains['id'] }}:9292"
                }
            },
            "nova": {
                "service_type": "compute",
                "description": "nova compute service",
                "endpoint": {
                    "publicurl": "http://{{ grains['id'] }}:8774/v2/%(tenant_id)s",
                    "internalurl": "http://{{ grains['id'] }}:8774/v2/%(tenant_id)s",
                    "adminurl": "http://{{ grains['id'] }}:8774/v2/%(tenant_id)s"
                }
            },
            "cinder": {
                "service_type": "volume",
                "description": "cinder volume service",
                "endpoint": {
                    "publicurl": "http://{{ grains['id'] }}:8776/v1/%(tenant_id)s",
                    "internalurl": "http://{{ grains['id'] }}:8776/v1/%(tenant_id)s",
                    "adminurl": "http://{{ grains['id'] }}:8776/v1/%(tenant_id)s"
                }
            },
            "neutron": {
                "service_type": "network",
                "description": "Openstack network service",
                "endpoint": {
                    "publicurl": "http://{{ grains['id'] }}:9696",
                    "internalurl": "http://{{ grains['id'] }}:9696",
                    "adminurl": "http://{{ grains['id'] }}:9696"
                }
            }
        }
    },
    "mysql": {
        "keystone": {
            "username": "keystone",
            "password": "keystone_pass",
            "sync": "keystone-manage db_sync",
            "service": "keystone"
        },
        "glance": {
            "username": "glance",
            "password": "glance_pass",
            "sync": "glance-manage db_sync",
            "service": "glance"
        },
        "cinder": {
            "username": "cinder",
            "password": "cinder_pass"
        },
        "nova": {
            "username": "nova",
            "password": "nova_pass",
            "sync": "nova-manage db sync",
            "service": "nova-api"
        },
        "neutron": {
            "username": "neutron",
            "password": "neutron_pass"
        },
        "dash": {
            "username": "dash",
            "password": "dash_pass"
        }
    },
    "DM": {
        "cpu": {
            "threshold": 70
        },
        "memory": {
            "threshold": 70
        },
        "swap": {
            "threshold": 70
        }
    },
    "hosts": {
        "hawk": "10.8.27.71",
        "lammer": "10.8.27.74"
    }
}
