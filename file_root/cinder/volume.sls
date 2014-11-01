lvm_pkg_install:
  pkg:
    - installed
    - name: {{ salt['pillar.get']('packages:lvm', default='lvm2') }}

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
    - name: "{{ salt['pillar.get']('packages:cinder_volume', default='cinder-volume') }}"
    - require:
      - pkg: lvm_pkg_install

cinder_config_file:
  file:
    - managed
    - name: "{{ salt['pillar.get']('conf_files:cinder', default='/etc/cinder/cinder.conf') }}"
    - user: cinder
    - group: cinder
    - mode: 644
    - require: 
      - pkg: cinder_volume_package
  ini:
    - options_present
    - name: "{{ salt['pillar.get']('conf_files:cinder', default='/etc/cinder/cinder.conf') }}"
    - sections:
        DEFAULT:
          rpc_backend: rabbit
          rabbit_host: "{{ salt['pillar.get']('queue_engine', default='rabbit') }}"
          rabbit_port: 5672
          glance_host: "{{ get_candidate('glance') }}"
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
      - file: cinder_config_file

cinder_volume_service:
  service:
    - running
    - name: "{{ salt['pillar.get']('services:cinder_volume', default='cinder-volume') }}"
    - watch:
      - ini: cinder_config_file

cinder_iscsi_target_service:
  service:
    - running
    - name: "{{ salt['pillar.get']('services:iscsi_target', default='tgt') }}"
    - watch:
      - ini: cinder_config_file
