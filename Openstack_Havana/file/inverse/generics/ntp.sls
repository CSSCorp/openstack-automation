#!jinja|json
{
    "ntp": {
        "pkg": [
            "installed",
            {
                "require": [
                    {
                        "file": "apt-cache-proxy"
                    },
                    {
                        "host": "salt"
                    }
                    {% for server in pillar['hosts'] %}
                    ,
                    {
                        "host": "{{ server }}"
                    }
                    {% endfor %}
                ]
            }
        ],
        "service": [
            "running",
            {
                "watch": [
                    {
                        "pkg": "ntp"
                    },
                    {
                        "file": "ntp"
                    }
                ]
            }
        ],
        "file": [
            "managed",
            {
                "name": "/etc/ntp.conf",
                "source": "salt://config/{{  pillar['config-folder'] }}/common/etc/ntp.conf",
                "require": [
                    {
                        "pkg": "ntp"
                    }
                ]
            }
        ]
    }
}
