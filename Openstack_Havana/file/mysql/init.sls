#!jinja|ast
{
    "mysql-server": {
        "pkg": [
            "installed"
        ],
        "service": [
            "running",
            {
                "name": "mysql"
            },
            {
                "watch": [
                    {
                        "pkg": "mysql-server"
                    },
                    {
                        "ini": "mysql-server"
                    }
                ]
            }
        ],
        "file": [
            "managed",
            {
                "name": "/etc/mysql/my.cnf",
                "user": "root",
                "group": "root",
                "mode": "644",
                "require": [
                    {
                        "pkg": "mysql-server"
                    }
                ]
            }
        ],
        "ini": [
			"options_present",
			{
				"name": "/etc/mysql/my.cnf",
				"sections": {
					"mysqld": {
						"bind-address": "0.0.0.0"
					}
				}
			},
			{
				"require": [
					{
						"file": "mysql-server"
					}
				]
			}
        ]
    }
}
