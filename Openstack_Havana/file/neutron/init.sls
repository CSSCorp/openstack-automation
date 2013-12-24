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
                        "file": "neutron-server"
                    }
                ]
            }
        ],
        "file": [
            "managed",
            {
                "name": "/etc/neutron/neutron.conf",
                "source": "salt://config/{{ pillar['config-folder'] }}/common/etc/neutron/neutron.conf",
                "require": [
                    {
                        "pkg": "neutron-server"
                    }
                ],
                "user": "neutron"
            }
        ]
    },
    "neutron-dhcp-agent": {
        "pkg": [
            "installed"
        ],
        "service": [
            "running",
            {
                "require": [
                    {
                        "pkg": "neutron-dhcp-agent"
                    },
                    {
                        "file": "neutron-dhcp-agent"
                    }
                ]
            }
        ],
        "file": [
            "managed",
            {
                "name": "/etc/neutron/dhcp_agent.ini",
                "source": "salt://config/{{ pillar['config-folder'] }}/common/etc/neutron/dhcp_agent.ini",
                "require": [
                    {
                        "pkg": "neutron-dhcp-agent"
                    }
                ],
                "user": "neutron"
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
                "require": [
                    {
                        "pkg": "neutron-metadata-agent"
                    },
                    {
                        "file": "neutron-metadata-agent"
                    }
                ]
            }
        ],
        "file": [
            "managed",
            {
                "name": "/etc/neutron/metadata_agent.ini",
                "source": "salt://config/{{ pillar['config-folder'] }}/common/etc/neutron/metadata_agent.ini",
                "require": [
                    {
                        "pkg": "neutron-metadata-agent"
                    }
                ],
                "user": "neutron"
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
                "require": [
                    {
                        "pkg": "neutron-l3-agent"
                    },
                    {
                        "file": "neutron-l3-agent"
                    }
                ]
            }
        ],
        "file": [
            "managed",
            {
                "name": "/etc/neutron/l3_agent.ini",
                "source": "salt://config/{{ pillar['config-folder'] }}/common/etc/neutron/l3_agent.ini",
                "require": [
                    {
                        "pkg": "neutron-l3-agent"
                    }
                ],
                "user": "neutron"
            }
        ]
    },
    "enable_forwarding": {
        "file": [
            "managed",
            {
                "name": "/etc/sysctl.conf",
                "source": "salt://config/{{ pillar['config-folder'] }}/common/etc/sysctl.conf"
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
    }
}
