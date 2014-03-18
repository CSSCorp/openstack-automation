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
                "name": "/etc/sysctl.conf"
            }
        ],
        "ini": [
			"options_present",
			{
				"name": "/etc/sysctl.conf",
				"sections": {
					"DEFAULT_IMPLICIT": {
						"net.ipv4.ip_forward": "0"
					}
				}
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
