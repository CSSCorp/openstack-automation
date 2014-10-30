{% from "cluster/resources.jinja" import get_candidate with context %}
neutron-plugin-openvswitch-agent: 
  pkg: 
    - installed
    - require: 
      - module: create_init_bridges
  service: 
    - running
    - watch: 
      - pkg: neutron-plugin-openvswitch-agent
      - ini: neutron-ovs-conf
  file: 
    - managed
    - name: /etc/neutron/plugins/openvswitch/ovs_neutron_plugin.ini
    - group: neutron
    - user: neutron
    - mode: 644
    - require: 
      - pkg: neutron-plugin-openvswitch-agent
neutron-ovs-conf: 
  file: 
    - managed
    - name: /etc/neutron/neutron.conf
    - group: neutron
    - user: neutron
    - mode: 644
    - require: 
      - pkg: neutron-plugin-openvswitch-agent
  ini: 
    - options_present
    - name: /etc/neutron/neutron.conf
    - sections: 
        DEFAULT: 
          rabbit_host: {{ get_candidate('queue.rabbit') }}
          neutron_metadata_proxy_shared_secret: {{ pillar['neutron']['metadata_secret'] }}
          service_neutron_metadata_proxy: true
          auth_strategy: keystone
          rpc_backend: neutron.openstack.common.rpc.impl_kombu
          core_plugin: ml2
          service_plugins: router
          allow_overlapping_ips: True
          verbose: True
        keystone_authtoken: 
          auth_protocol: http
          admin_user: neutron
          admin_password: {{ pillar['keystone']['tenants']['service']['users']['neutron']['password'] }}
          auth_host: {{ salt['cluster_ops.get_candidate']('keystone') }}
          auth_uri: http://{{ salt['cluster_ops.get_candidate']('keystone') }}:5000
          admin_tenant_name: service
          auth_port: 35357
    - require: 
        - file: neutron-ovs-conf
openvswitch-switch: 
  pkg: 
    - installed
  service: 
    - running
    - require: 
      - pkg: openvswitch-switch
create_init_bridges: 
  module: 
    - run
    - name: cluster_ops.create_init_bridges
    - require: 
      - service: openvswitch-switch
