#!jinja|json
{
    "python-software-properties": {
        "pkg": [
            "installed"
        ]
    },
    "ubuntu-cloud-keyring": {
        "pkg": [
            "installed",
            {
                "require": [
                    {
                        "pkg": "python-software-properties",
                        "cmd": "pkg_update",
                        "pkg": "linux-headers-generic-pae"
                    }
                ]
            }
        ]
    },
    "cloudarchive-havana.list": {
        "file": [
            "managed",
            {
                "name": "/etc/apt/sources.list.d/cloudarchive-havana.list",
                "source": "salt://config/{{  pillar['config-folder'] }}/common/etc/apt/sources.list.d/cloudarchive-havana.list",
                "require": [
                    {
                        "file": "apt-cache-proxy"
                    }
                ]
            }
        ]
    },
    "pkg_update": {
        "cmd": [
            "run",
            {
                "name": "apt-get update"
            },
            {
                "require": [
                    {
                        "file": "cloudarchive-havana.list"
                    }
                ]
            }
        ]
    },
    "apt-cache-proxy": {
        "file": [
            "managed",
            {
                "name": "/etc/apt/apt.conf.d/01proxy",
                "source": "salt://config/{{  pillar['config-folder'] }}/common/etc/apt/apt.conf.d/01proxy"
            }
        ]
    },
    "linux-headers-generic-pae": {
        "pkg": [
            "installed",
            {
                "require": [
                        {
                            "file": "apt-cache-proxy"
                        }
                ]
            }
        ]
    }
}
