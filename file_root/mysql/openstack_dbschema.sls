{% for database_name in pillar['mysql'] %}
{{ database_name }}-db:
  mysql_database:
    - present
    - name: {{ database_name }}
{% for server in salt['cluster_ops.list_hosts']() %}
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
