#!jinja|ast
{
    "mysql-refresh-repo": {
		"module": [
			"run",
			{
				"name": "saltutil.sync_all"
			},
            {
                "require": [
                    {
                        "pkg": "python-mysqldb"
                    }
                ]
            }
		]
    }
{% for database_name in pillar['mysql'] %}
   ,"{{ database_name }}-db": {
        "mysql_database": [
            "present",
            {
                "name": "{{ database_name }}"
            },
            {
                "require": [
					{
						"service": "mysql-server"
					},
                    {
                        "module": "mysql-refresh-repo"
                    }
                ]
            }
        ]
    }
{% for cluster_component in pillar['install'] %}
{% for server in pillar[cluster_component] %}
   ,"{{ server }}-{{ database_name }}-accounts": {
      "mysql_user": [
            "present",
            {
                "name": "{{ pillar['mysql'][database_name]['username'] }}",
                "password": "{{ pillar['mysql'][database_name]['password'] }}",
                "host": "{{ server }}",
                "require": [
                    {
                        "mysql_database": "{{ database_name }}-db"
                    }
                ]
            }
        ],
        "mysql_grants": [
            "present",
            {
                "grant": "all",
                "database": "{{ database_name }}.*",
                "user": "{{ pillar['mysql'][database_name]['username'] }}",
                "host": "{{ server }}",
                "password": "{{ pillar['mysql'][database_name]['password'] }}",
                "require": [
                    {
                        "mysql_user": "{{ server }}-{{ database_name }}-accounts"
                    }
                ]
            }
        ]
    }
{% endfor %}
{% endfor %}
{% endfor %}
}
