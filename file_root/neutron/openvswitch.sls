{% from "cluster/resources.jinja" import get_candidate with context %}
neutron-l2-agent-install: 
  pkg: 
    - installed
    - name: {{ salt['pillar.get']('packages:neutron_l2_agent', default='neutron-plugin-openvswitch-agent') }}
    - require: 
      - module: create_init_bridges

neutron-l2-agent-running:
  service: 
    - running
    - name: {{ salt['pillar.get']('services:neutron_l2_agent', default='neutron-plugin-openvswitch-agent') }}
    - watch: 
      - pkg: neutron-l2-agent-install
      - file: l2-agent-neutron-config-file
      - file: l2-agent-config-file

l2-agent-config-file:
  file: 
    - managed
    - name: {{ salt['pillar.get']('conf_files:neutron_l2_agent', default='/etc/neutron/plugins/openvswitch/ovs_neutron_plugin.ini') }}
    - group: neutron
    - user: neutron
    - mode: 644
    - require: 
      - pkg: neutron-l2-agent-install

l2-agent-neutron-config-file: 
  file: 
    - managed
    - name: {{ salt['pillar.get']('conf_files:neutron_l2_agent', default='/etc/neutron/neutron.conf') }}
    - group: neutron
    - user: neutron
    - mode: 644
    - require: 
      - ini: l2-agent-neutron-config-file
  ini: 
    - options_present
    - name: {{ salt['pillar.get']('conf_files:neutron_l2_agent', default='/etc/neutron/neutron.conf') }}
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
      - pkg: neutron-l2-agent-install


openvswitch-switch-install: 
  pkg: 
    - installed
    - name: {{ salt['pillar.get']('packages:openvswitch', default='openvswitch-switch') }}

openvswitch-switch-running:
  service: 
    - running
    - name: {{ salt['pillar.get']('services:openvswitch', default='openvswitch-switch') }}
    - require: 
      - pkg: openvswitch-switch-install

create_init_bridges: 
  module: 
    - run
    - name: cluster_ops.create_init_bridges
    - require: 
      - service: openvswitch-switch
