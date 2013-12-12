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
                        "file": "mysql-server"
                    }
                ]
            }
        ],
        "file": [
            "managed",
            {
                "name": "/etc/mysql/my.cnf",
                "source": "salt://config/{{  pillar['config-folder'] }}/common/etc/mysql/my.cnf",
                "require": [
                    {
                        "pkg": "mysql-server"
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
                        "pkg": "mysql-server"
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
                "grant": "all privileges",
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
{% if 'sync' in pillar['mysql'][database_name] %}
    ,"{{ database_name }}_sync": {
        "cmd": [
            "run",
            {
                "name": "{{ pillar['mysql'][database_name]['sync'] }}"
            },
            {
                "require": [
                    {
                        "service": "{{ pillar['mysql'][database_name]['service'] }}"
                    },
                    {
                        "mysql_grants": "{{ grains['id'] }}-{{ database_name }}-accounts"
                    }
                ]
            }
        ]
    }
{% endif %}
{% endfor %}
}
