{% from "cluster/resources.jinja" import hosts with context %}
{% for openstack_service in pillar['databases'] %}
{% for database_name in pillar['databases'][openstack_service] %}
{{ database_name }}-db:
  mysql_database:
    - present
    - name: {{ database_name }}
{% for server in hosts %}
{{ server }}-{{ database_name }}-accounts:
  mysql_user:
    - present
    - name: {{ pillar['databases'][openstack_service][database_name]['username'] }}
    - password: {{ pillar['databases'][openstack_service][database_name]['password'] }}
    - host: {{ server }}
    - require:
      - mysql_database: {{ database_name }}-db
  mysql_grants:
    - present
    - grant: all
    - database: {{ database_name }}
    - user: {{ pillar['databases'][openstack_service][database_name]['username'] }}
    - password: {{ pillar['databases'][openstack_service][database_name]['password'] }}
    - require:
      - mysql_user: {{ server }}-{{ database_name }}-accounts
{% endfor %}
{% endfor %}
{% endfor %}
