#!jinja|json
{
    "keystone.endpoint": "http://hawk:35357/v2.0", 
    "DM": {
        "swap": {
            "threshold": 70, 
            "actions": {
                "email": {
                    "destination": "ageeleshwar.kandavelu@csscorp.com"
                }
            }
        }, 
        "cpu": {
            "threshold": 70, 
            "actions": {
                "email": {
                    "destination": "ageeleshwar.kandavelu@csscorp.com"
                }
            }
        }, 
        "memory": {
            "threshold": 70, 
            "actions": {
                "scale": {
                    "types": [
                        "compute"
                    ]
                }, 
                "email": {
                    "destination": "ageeleshwar.kandavelu@csscorp.com"
                }
            }
        }
    }, 
    "compute": [
        "lammergeier"
    ], 
    "schedule": {
        "salt-monitor": {
            "function": "metric_monitor.monitor", 
            "minutes": 5
        }
    }, 
    "cluster_type": "openstack", 
    "mysql": {
        "nova": {
            "username": "nova", 
            "password": "nova_pass", 
            "sync": "nova-manage db sync", 
            "service": "nova-api"
        }, 
        "dash": {
            "username": "dash", 
            "password": "dash_pass"
        }, 
        "keystone": {
            "username": "keystone", 
            "password": "keystone_pass", 
            "sync": "keystone-manage db_sync", 
            "service": "keystone"
        }, 
        "cinder": {
            "username": "cinder", 
            "password": "cinder_pass"
        }, 
        "glance": {
            "username": "glance", 
            "password": "glance_pass", 
            "sync": "glance-manage db_sync", 
            "service": "glance"
        }, 
        "neutron": {
            "username": "neutron", 
            "password": "neutron_pass"
        }
    }, 
    "cluster_name": "cluster1", 
    "controller": [
        "hawk"
    ], 
    "keystone": {
        "endpoint": "http://hawk:35357/v2.0", 
        "roles": [
            "admin", 
            "Member"
        ], 
        "token": "24811ee3d9a09915bef0", 
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
                "description": "keystone identity service"
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
                        "role": "admin", 
                        "email": "salt@csscorp.com"
                    }
                }
            }, 
            "service": {
                "users": {
                    "cinder": {
                        "password": "cinder_pass", 
                        "role": "admin", 
                        "email": "salt@csscorp.com"
                    }, 
                    "glance": {
                        "password": "glance_pass", 
                        "role": "admin", 
                        "email": "salt@csscorp.com"
                    }, 
                    "neutron": {
                        "password": "neutron_pass", 
                        "role": "admin", 
                        "email": "salt@csscorp.com"
                    }, 
                    "nova": {
                        "password": "nova_pass", 
                        "role": "admin", 
                        "email": "salt@csscorp.com"
                    }
                }
            }
        }, 
        "dbname": "keystone"
    }, 
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
    "hosts": {
        "lammergeier": "10.8.27.74", 
        "hawk": "10.8.27.71", 
        "osprey": "10.8.27.73"
    }, 
    "scale_options": [], 
    "salt-master": "10.8.27.28", 
    "config-folder": "cluster1",
    "keystone.auth_url": "http://hawk:5000/v2.0/", 
    "keystone.token": "24811ee3d9a09915bef0"
}
