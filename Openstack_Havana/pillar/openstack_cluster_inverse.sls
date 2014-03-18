#!jinja|json
{
    "controller": [
        "mercury"
    ],
    "compute": [
        "venus"
    ],
    "network": [
		"mercury"
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
    }
}
