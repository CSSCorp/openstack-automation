cinder_api_pkg:
  pkg:
    - installed
    - name: "cinder-api"


cinder_scheduler_pkg:
  pkg:
    - installed
    - name: "cinder-scheduler"

cinder_volume_config_file:
  file:
    - managed
    - name: /etc/cinder/cinder.conf
    - user: cinder
    - group: cinder
    - mode: 644
    - require: 
      - pkg: cinder_api_pkg
      - pkg: cinder_scheduler_pkg

cinder_config_options:
  ini:
    - options_present
    - name: "/etc/cinder/cinder.conf"
    - sections:
        DEFAULT:
          rpc_backend: rabbit
          rabbit_host: {{ salt['cluster_ops.get_candidate']('queue.' + pillar['queue-engine']) }}
          rabbit_port: 5672
          glance_host: {{ salt['cluster_ops.get_candidate']('glance') }}
        database:
          connection: mysql://{{ pillar['mysql'][pillar['services']['cinder']['db_name']]['username'] }}:{{ pillar['mysql'][pillar['services']['cinder']['db_name']]['password'] }}@{{ salt['cluster_ops.get_candidate']('mysql') }}/{{ pillar['services']['cinder']['db_name'] }}
        keystone_authtoken:
          auth_uri: {{ salt['cluster_ops.get_candidate']('keystone') }}:5000
          auth_port: 35357
          auth_protocol: http
          admin_tenant_name: service
          admin_user: cinder
          admin_password: {{ pillar['keystone']['tenants']['service']['users']['cinder']['password'] }}
          auth_host: {{ salt['cluster_ops.get_candidate']('keystone') }}
    - require:
      - file: cinder_volume_config_file

cinder_sync:
  cmd:
    - run
    - name: {{ pillar['openstack-services-sync']['cinder']['db_sync'] }}
    - require:
      - service: "cinder-api"
      - service: "cinder-scheduler"

cinder-api-service:
  service:
    - running
    - name: "cinder-api"
    - watch:
      - ini: cinder_config_options

cinder-scheduler-service:
  service:
    - running
    - name: "cinder-scheduler"
    - watch:
      - ini: cinder_config_options
