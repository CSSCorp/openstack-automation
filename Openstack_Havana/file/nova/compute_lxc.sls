#!jinja|json
{
    "nova-compute-lxc": {
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
                        "file": "nova-compute-conf"
                    }
                ]
            }
        ],
        "file": [
            "managed",
            {
                "name": "/etc/nova/nova-compute.conf",
                "source": "salt://config/{{ pillar['config-folder'] }}/{{ grains['id'] }}/etc/nova/nova-compute.conf",
                "require": [
                    {
                        "pkg": "nova-compute"
                    }
                ],
                "user": "nova"
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
                "source": "salt://config/{{ pillar['config-folder'] }}/{{ grains['id'] }}/etc/nova/nova.conf",
                "require": [
                    {
                        "pkg": "nova-compute-lxc"
                    }
                ],
                "user": "nova"
            }
        ]
    },
    "nova-api-paste": {
        "file": [
            "managed",
            {
                "name": "/etc/nova/api-paste.ini",
                "source": "salt://config/{{ pillar['config-folder'] }}/{{ grains['id'] }}/etc/nova/api-paste.ini",
                "require": [
                    {
                        "pkg": "nova-compute-lxc"
                    }
                ],
                "user": "nova"
            }
        ]
    }
}
