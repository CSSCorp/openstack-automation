#!jinja|json
{
    "memcached": {
        "pkg": [
            "installed"
        ],
        "service": [
            "running",
            {
                "watch": [
                    {
                      "pkg": "memcached"
                    },
                    {
                        "file": "memcached"
                    }
                ]
            }
        ],
        "file": [
            "managed",
            {
                "name": "/etc/memcached.conf",
                "source": "salt://config/{{ pillar['config-folder'] }}/common/etc/memcached.conf",
                "require": [
                    {
                        "pkg": "memcached"
                    }
                ]
            }
        ]
    },
    "libapache2-mod-wsgi": {
        "pkg": [
            "installed"
        ],
        "service": [
            "running",
            {
                "name": "apache2"
            },
            {
                "watch": [
                    {
                      "pkg": "libapache2-mod-wsgi"
                    }
                ]
            }
        ]
    },
    "openstack-dashboard": {
        "pkg": [
            "installed"
        ],
        "file": [
            "managed",
            {
                "name": "/etc/openstack-dashboard/local_settings.py",
                "source": "salt://config/{{ pillar['config-folder'] }}/common/etc/openstack-dashboard/local_settings.py",
                "require": [
                    {
                        "pkg": "openstack-dashboard"
                    }
                ]
            }
        ]
    }
}
