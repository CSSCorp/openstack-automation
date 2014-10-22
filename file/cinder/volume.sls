lvm_pkg_install:
  pkg:
    - installed
    - name: lvm2

lvm_physical_volume:
  lvm:
    - pv_present
    - name: "/dev/sda4"
    - require:
      - pkg: lvm_pkg_install

lvm_logical_volume:
  lvm:
    - vg_present
    - name: "cinder-volumes"
    - devices:
      - "/dev/sda4"
    - require:
      - lvm: lvm_physical_volume

cinder_volume_package:
  pkg:
    - installed
    - name: cinder-volume
    - require:
      - pkg: lvm_pkg_install


cinder_volume_config_file:
  file:
    - managed
    - name: /etc/cinder/cinder.conf
    - user: cinder
    - group: cinder
    - mode: 644
    - require: 
      - pkg: cinder_volume_package

cinder_volume_config_options:
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

cinder_volume_service:
  service:
    - running
    - name: cinder-volume
    - watch:
      - ini: cinder_volume_config_options

cinder_iscsi_target_service:
  service:
    - running
    - name: tgt
    - watch:
      - ini: cinder_volume_config_options