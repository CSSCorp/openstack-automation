#!jinja|json
{
    "glance": {
        "pkg": [
            "installed"
        ],
        "service": [
            "running",
            {
                "names": ["glance-registry", "glance-api"]
            },
            {
                "watch": [
                    {
                        "pkg": "glance"
                    },
                    {
                        "file": "glance-api-conf"
                    },
                    {
                        "file": "glance-registry-conf"
                    }
                ]
            }
        ]
    },
    "glance-api-conf": {
        "file": [
            "managed",
            {
                "name": "/etc/glance/glance-api.conf",
                "source": "salt://config/{{ pillar['config-folder'] }}/common/etc/glance/glance-api.conf",
                "require": [
                    {
                        "pkg": "glance"
                    }
                ],
                "user": "glance"
            }
        ]
    },
    "glance-registry-conf": {
        "file": [
            "managed",
            {
                "name": "/etc/glance/glance-registry.conf",
                "source": "salt://config/{{ pillar['config-folder'] }}/common/etc/glance/glance-registry.conf",
                "require": [
                    {
                        "pkg": "glance"
                    }
                ],
                "user": "glance"
            }
        ]
    },
    "glance_sqlite_delete": {
        "file": [
            "absent",
            {
                "name": "/var/lib/glance/glance.sqlite"
            },
            {
                "require": [
                    {
                        "pkg": "glance"
                    }
                ]
            }
        ]
    }
}
