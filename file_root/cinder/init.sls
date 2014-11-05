{% from "cluster/resources.jinja" import get_candidate with context %}

cinder_api_pkg:
  pkg:
    - installed
    - name: "{{ salt['pillar.get']('packages:cinder_api', default='cinder-api') }}"


cinder_scheduler_pkg:
  pkg:
    - installed
    - name: "{{ salt['pillar.get']('packages:cinder_scheduler', default='cinder-scheduler') }}"

cinder_config_file:
  file:
    - managed
    - name: "{{ salt['pillar.get']('conf_files:cinder', default='/etc/cinder/cinder.conf') }}"
    - user: cinder
    - group: cinder
    - mode: 644
    - require: 
      - ini: cinder_config_file
  ini:
    - options_present
    - name: "{{ salt['pillar.get']('conf_files:cinder', default='/etc/cinder/cinder.conf') }}"
    - sections:
        DEFAULT:
          rpc_backend: "{{ salt['pillar.get']('queue_engine', default='rabbit') }}"
          rabbit_host: "{{ get_candidate('queue.%s' % salt['pillar.get']('queue_engine', default='rabbit')) }}"
          rabbit_port: 5672
          cinder_host: "{{ get_candidate('glance') }}"
        database:
          connection: "mysql://{{ salt['pillar.get']('databases:cinder:username', default='cinder') }}:{{ salt['pillar.get']('databases:cinder:password', default='cinder_pass') }}@{{ get_candidate('mysql') }}/{{ salt['pillar.get']('databases:cinder:db_name', default='cinder') }}"
        keystone_authtoken:
          auth_uri: "{{ get_candidate('keystone') }}:5000"
          auth_port: 35357
          auth_protocol: http
          admin_tenant_name: service
          admin_user: cinder
          admin_password: "{{ pillar['keystone']['tenants']['service']['users']['cinder']['password'] }}"
          auth_host: "{{ get_candidate('keystone') }}"
    - require:
      - pkg: cinder_api_pkg
      - pkg: cinder_scheduler_pkg


{% if 'db_sync' in salt['pillar.get']('databases:cinder', default=()) %}
cinder_sync:
  cmd:
    - run
    - name: "{{ salt['pillar.get']('databases:cinder:db_sync') }}"
    - require:
      - service: "cinder-api-service"
      - service: "cinder-scheduler-service"
{% endif %}


cinder-api-service:
  service:
    - running
    - name: "{{ salt['pillar.get']('services:cinder_api', default='cinder-api') }}"
    - watch:
      - ini: cinder_config_file
      - file: cinder_config_file

cinder-scheduler-service:
  service:
    - running
    - name: "{{ salt['pillar.get']('services:cinder_scheduler', default='cinder-scheduler') }}"
    - watch:
      - ini: cinder_config_file
      - file: cinder_config_file
