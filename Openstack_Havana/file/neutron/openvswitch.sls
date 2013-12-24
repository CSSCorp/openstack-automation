#!jinja|json
{
    "neutron-plugin-openvswitch-agent": {
        "pkg": [
            "installed"
        ],
        "service": [
            "running",
            {
                "watch": [
                    {
                        "pkg": "neutron-plugin-openvswitch-agent"
                    },
                    {
                        "file": "neutron-plugin-openvswitch-agent"
                    }
                ]
            }
        ],
        "file": [
            "managed",
            {
                "name": "/etc/neutron/plugins/openvswitch/ovs_neutron_plugin.ini",
                "source": "salt://config/{{ pillar['config-folder'] }}/{{ grains['id'] }}/etc/neutron/plugins/openvswitch/ovs_neutron_plugin.ini",
                "require": [
                    {
                        "pkg": "neutron-plugin-openvswitch-agent"
                    }
                ],
                "user": "neutron"
            }
        ]
    },
    "neutron-conf": {
        "file": [
            "managed",
            {
                "name": "/etc/neutron/neutron.conf",
                "source": "salt://config/{{ pillar['config-folder'] }}/common/etc/neutron/neutron.conf",
                "require": [
                    {
                        "pkg": "neutron-plugin-openvswitch-agent"
                    }
                ],
                "user": "neutron"
            }
        ]
    },
    "neutron-api-paste": {
        "file": [
            "managed",
            {
                "name": "/etc/neutron/api-paste.ini",
                "source": "salt://config/{{ pillar['config-folder'] }}/common/etc/neutron/api-paste.ini",
                "require": [
                    {
                        "pkg": "neutron-plugin-openvswitch-agent"
                    }
                ],
                "user": "neutron"
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
    }
}
