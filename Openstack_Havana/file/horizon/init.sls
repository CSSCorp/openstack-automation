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
        ]
    }
}
