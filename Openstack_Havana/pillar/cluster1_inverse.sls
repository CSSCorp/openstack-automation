#!jinja|json
{
    "controller": [
        "hawk"
    ],
    "compute": [
        "lammergeier",
        "osprey"
    ],
    "install": {
        "controller": [
            "inverse.generics.host",
            "inverse.generics.havana",
            "inverse.generics.ntp",
            "inverse.mysql",
            "inverse.queue.rabbit",
            "inverse.keystone",
            "inverse.glance",
            "inverse.nova",
            "inverse.mysql.client",
            "inverse.horizon",
            "inverse.neutron",
            "inverse.neutron.openvswitch",
            "inverse.autoremove"
        ],
        "compute": [
            "inverse.generics.host",
            "inverse.generics.havana",
            "inverse.generics.ntp",
            "inverse.mysql.client",
            "inverse.nova.compute_lxc",
            "inverse.neutron.openvswitch",
            "inverse.autoremove"
        ]
    },
    "config-folder": "cluster1_inverse",
    "keystone.token": "24811ee3d9a09915bef0",
    "keystone.endpoint": "http://hawk:35357/v2.0",
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
        "lammergeier": "10.8.27.74",
        "osprey": "10.8.27.73"
    },
    "salt-master": "10.8.27.28"
}
