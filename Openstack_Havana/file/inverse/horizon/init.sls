#!jinja|json
{
    "memcached": {
        "pkg": [
            "purged"
        ]
    },
    "libapache2-mod-wsgi": {
        "pkg": [
            "purged",
            {
                "names": ["apache2", "libapache2-mod-wsgi"]
            }
        ]
    },
    "openstack-dashboard": {
        "pkg": [
            "purged"
        ]
    }
}
