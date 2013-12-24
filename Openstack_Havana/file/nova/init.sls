#!jinja|json
{
    "nova-api": {
        "pkg": [
            "installed"
        ],
        "service": [
            "running",
            {
                "watch": [
                    {
                        "file": "nova-conf"
                    },
                    {
                        "file": "nova-api-paste"
                    }
                ]
            }
        ]
    },
    "nova-conductor": {
        "pkg": [
            "installed"
        ],
        "service": [
            "running",
            {
                "watch": [
                    {
                        "file": "nova-conf"
                    },
                    {
                        "file": "nova-api-paste"
                    }
                ]
            }
        ]
    },
    "nova-scheduler": {
        "pkg": [
            "installed"
        ],
        "service": [
            "running",
            {
                "watch": [
                    {
                        "file": "nova-conf"
                    },
                    {
                        "file": "nova-api-paste"
                    }
                ]
            }
        ]
    },
    "nova-cert": {
        "pkg": [
            "installed"
        ],
        "service": [
            "running",
            {
                "watch": [
                    {
                        "file": "nova-conf"
                    },
                    {
                        "file": "nova-api-paste"
                    }
                ]
            }
        ]
    },
    "nova-consoleauth": {
        "pkg": [
            "installed"
        ],
        "service": [
            "running",
            {
                "watch": [
                    {
                        "file": "nova-conf"
                    },
                    {
                        "file": "nova-api-paste"
                    }
                ]
            }
        ]
    },
    "nova-doc": {
        "pkg": [
            "installed"
        ]
    },
    "python-novaclient": {
        "pkg": [
            "installed"
        ]
    },
    "nova-ajax-console-proxy": {
        "pkg": [
            "installed"
        ]
    },
    "novnc": {
        "pkg": [
            "installed"
        ]
    },
    "nova-novncproxy": {
        "pkg": [
            "installed"
        ],
        "service": [
            "running",
            {
                "watch": [
                    {
                        "file": "nova-conf"
                    },
                    {
                        "file": "nova-api-paste"
                    }
                ]
            }
        ]
    },
    "nova_sqlite_delete": {
        "file": [
            "absent",
            {
                "name": "/var/lib/nova/nova.sqlite"
            },
            {
                "require": [
                    {
                        "pkg": "nova-api"
                    }
                ]
            }
        ]
    },
    "nova-conf": {
        "file": [
            "managed",
            {
                "name": "/etc/nova/nova.conf",
                "source": "salt://config/{{ pillar['config-folder'] }}/common/etc/nova/nova.conf",
                "require": [
                    {
                        "pkg": "nova-api"
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
                "source": "salt://config/{{ pillar['config-folder'] }}/common/etc/nova/api-paste.ini",
                "require": [
                    {
                        "pkg": "nova-api"
                    }
                ],
                "user": "nova"
            }
        ]
    }
}
