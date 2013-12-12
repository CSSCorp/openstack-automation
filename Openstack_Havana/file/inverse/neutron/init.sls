#!jinja|json
{
    "neutron-server": {
        "pkg": [
            "purged"
        ]
    },
    "neutron-dhcp-agent": {
        "pkg": [
            "purged"
        ]
    },
    "neutron-metadata-agent": {
        "pkg": [
            "purged"
        ]
    },
    "neutron-l3-agent": {
        "pkg": [
            "purged"
        ]
    },
    "disable_forwarding": {
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
                        "file": "disable_forwarding"
                    }
                ]
            }
        ]
    }
}
