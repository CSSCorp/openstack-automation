{% from "cluster/resources.jinja" import get_candidate with context %}
{% from "cluster/physical_networks.jinja" import bridges with context %}
neutron-l2-agent-install: 
  pkg: 
    - installed
    - name: "{{ salt['pillar.get']('packages:neutron_l2_agent', default='neutron-plugin-openvswitch-agent') }}"
    - require: 
      - module: create_init_bridges

neutron-l2-agent-running:
  service: 
    - running
    - name: "{{ salt['pillar.get']('services:neutron_l2_agent', default='neutron-plugin-openvswitch-agent') }}"
    - watch: 
      - pkg: neutron-l2-agent-install
      - file: l2-agent-neutron-config-file
      - file: l2-agent-config-file

l2-agent-config-file:
  file: 
    - managed
    - name: "{{ salt['pillar.get']('conf_files:neutron_l2_agent', default='/etc/neutron/plugins/openvswitch/ovs_neutron_plugin.ini') }}"
    - group: neutron
    - user: neutron
    - mode: 644
    - require: 
      - pkg: neutron-l2-agent-install

l2-agent-neutron-config-file: 
  file: 
    - managed
    - name: "{{ salt['pillar.get']('conf_files:neutron', default='/etc/neutron/neutron.conf') }}"
    - group: neutron
    - user: neutron
    - mode: 644
    - require: 
      - ini: l2-agent-neutron-config-file
  ini: 
    - options_present
    - name: "{{ salt['pillar.get']('conf_files:neutron', default='/etc/neutron/neutron.conf') }}"
    - sections: 
        DEFAULT: 
          rabbit_host: "{{ get_candidate('queue.%s' % salt['pillar.get']('queue_engine', default='rabbit')) }}"
          neutron_metadata_proxy_shared_secret: "{{ pillar['neutron']['metadata_secret'] }}"
          service_neutron_metadata_proxy: true
          auth_strategy: keystone
          rpc_backend: neutron.openstack.common.rpc.impl_kombu
          core_plugin: neutron.plugins.ml2.plugin.Ml2Plugin
          service_plugins: neutron.services.l3_router.l3_router_plugin.L3RouterPlugin
          allow_overlapping_ips: True
          verbose: True
        keystone_authtoken: 
          auth_protocol: http
          admin_user: neutron
          admin_password: "{{ pillar['keystone']['tenants']['service']['users']['neutron']['password'] }}"
          auth_host: "{{ get_candidate('keystone') }}"
          auth_uri: "http://{{ get_candidate('keystone') }}:5000"
          admin_tenant_name: service
          auth_port: 35357
    - require: 
      - pkg: neutron-l2-agent-install


openvswitch-switch-install: 
  pkg: 
    - installed
    - name: "{{ salt['pillar.get']('packages:openvswitch', default='openvswitch-switch') }}"

openvswitch-switch-running:
  service: 
    - running
    - name: "{{ salt['pillar.get']('services:openvswitch', default='openvswitch-switch') }}"
    - require: 
      - pkg: openvswitch-switch-install

{% for bridge in bridges %}
bridge-{{ bridge }}-create: 
  cmd: 
    - run
    - name: "ovs-vsctl add-br {{ bridge }}"
    - unless: "ovs-vsctl br-exists {{ bridge }}"
    - require: 
      - service: openvswitch-switch-running
{% if bridges[bridge] %}
{% if salt['pillar.get']('neutron:single_nic') %}
{% if bridges[bridge] not in salt['network.interfaces']() %}
veth-add-{{ bridges[bridge] }}:
  cmd:
    - run
    - name: "ip link add {{ bridges[bridge] }} type veth peer name {{ bridges[bridge] }}-br-proxy"
  network:
    - managed
    - name: "{{ bridges[bridge] }}-br-proxy"
    - enabled: True
    - require:
      - cmd: veth-add-{{ bridges[bridge] }}
{% endif %}
{% endif %}
{{ bridge }}-interface-add:
  cmd:
    - run
    - name: "ovs-vsctl add-port {{ bridge }} {{ bridges[bridge] }}"
    - unless: "ovs-vsctl list-ports {{ bridge }} | grep {{ bridges[bridge] }}"
    - require: 
      - cmd: "bridge-{{ bridge }}-create"
  network:
    - managed
    - name: "{{ bridges[bridge] }}"
    - enabled: True
    - require:
      - cmd: {{ bridge }}-interface-add
{% endif %}
{% endfor %}
