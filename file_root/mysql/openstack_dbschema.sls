{% from "cluster/resources.jinja" import hosts with context %}
{% for openstack_service in pillar['databases'] %}
{{ openstack_service }}-db:
  mysql_database:
    - present
    - name: {{ pillar['databases'][openstack_service]['db_name'] }}
    - character_set: 'utf8'
{% for server in hosts %}
{{ server }}-{{ openstack_service }}-accounts:
  mysql_user:
    - present
    - name: {{ pillar['databases'][openstack_service]['username'] }}
    - password: {{ pillar['databases'][openstack_service]['password'] }}
    - host: {{ server }}
    - require:
      - mysql_database: {{ openstack_service }}-db
  mysql_grants:
    - present
    - grant: all
    - database: "{{ pillar['databases'][openstack_service]['db_name'] }}.*"
    - user: {{ pillar['databases'][openstack_service]['username'] }}
    - password: {{ pillar['databases'][openstack_service]['password'] }}
    - host: {{ server }}
    - require:
      - mysql_user: {{ server }}-{{ openstack_service }}-accounts
{% endfor %}
{% endfor %}
