neutron-server-install: 
  pkg: 
    - installed
    - name: "{{ salt['pillar.get']('packages:neutron_server', default='neutron-server') }}"

neutron-server-service:
  service: 
    - running
    - name: "{{ salt['pillar.get']('services:neutron_server', default='neutron-server') }}"
    - watch: 
        - pkg: neutron-server-install
        - ini: neutron-conf-file
        - file: neutron-conf-file

neutron-conf-file:
  file: 
    - managed
    - name: "{{ salt['pillar.get']('conf_files:neutron', default='/etc/neutron/neutron.conf') }}"
    - user: neutron
    - group: neutron
    - mode: 644
    - require: 
      - pkg: neutron-server-install
  ini: 
    - options_present
    - name: "{{ salt['pillar.get']('conf_files:neutron', default='/etc/neutron/neutron.conf') }}"
    - sections: 
        DEFAULT: 
          rabbit_host: "{{ salt['cluster_ops.get_install_flavor']('queue.*') }}"
          auth_strategy: keystone
          rpc_backend: neutron.openstack.common.rpc.impl_kombu
          core_plugin: neutron.plugins.ml2.plugin.Ml2Plugin
          service_plugins: neutron.services.l3_router.l3_router_plugin.L3RouterPlugin
          allow_overlapping_ips: True
          verbose: True
          notify_nova_on_port_status_changes: True
          notify_nova_on_port_data_changes: True
          nova_url: "http://{{ salt['cluster_ops.get_candidate']('keystone') }}:8774/v2"
          nova_admin_username: nova
          nova_admin_tenant_id: service
          nova_admin_password: "{{ pillar['keystone']['tenants']['service']['users']['nova']['password'] }}"
          nova_admin_auth_url: "http://{{ salt['cluster_ops.get_candidate']('keystone') }}:35357/v2.0"
        keystone_authtoken: 
          auth_protocol: http
          admin_user: neutron
          admin_password: "{{ pillar['keystone']['tenants']['service']['users']['neutron']['password'] }}"
          auth_host: "{{ salt['cluster_ops.get_candidate']('keystone') }}"
          auth_uri: "http://{{ salt['cluster_ops.get_candidate']('keystone') }}:5000"
          admin_tenant_name: service
          auth_port: 35357
        database: 
          connection: "mysql://{{ salt['pillar.get']('databases:neutron:username', default='neutron') }}:{{ salt['pillar.get']('databases:neutron:password', default='neutron_pass') }}@{{ salt['cluster_ops.get_candidate']('mysql') }}/{{ salt['pillar.get']('databases:neutron:db_name', default='neutron') }}"
    - require: 
      - file: neutron-conf-file
