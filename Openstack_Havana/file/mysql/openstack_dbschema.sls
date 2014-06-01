<<<<<<< HEAD
{% for database_name in pillar['mysql'] %}
{{ database_name }}-db:
  mysql_database:
    - present
    - name: {{ database_name }}
=======
#!jinja|ast
{
    "mysql-refresh-repo": {
		"module": [
			"run",
			{
				"name": "saltutil.sync_all"
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
                        "module": "mysql-refresh-repo"
                    }
                ]
            }
        ]
    }
>>>>>>> cd189cab2257ed583018c889d11b66839b1262d7
{% for cluster_component in pillar['install'] %}
{% for server in pillar[cluster_component] %}
{{ server }}-{{ database_name }}-accounts:
  mysql_user:
    - present
    - name: {{ pillar['mysql'][database_name]['username'] }}
    - password: {{ pillar['mysql'][database_name]['password'] }}
    - host: {{ server }}
    - require:
      - mysql_database: {{ database_name }}-db
  mysql_grants:
    - present
    - grant: all
    - database: {{ database_name }}
    - user: {{ pillar['mysql'][database_name]['username'] }}
    - password: {{ pillar['mysql'][database_name]['password'] }}
    - require:
      - mysql_user: {{ server }}-{{ database_name }}-accounts
{% endfor %}
{% endfor %}
{% endfor %}
}
