{% from "cluster/resources.jinja" import get_candidate with context %}
{% from "cluster/physical_networks.jinja" import bridges with context %}
neutron-l2-agent-install: 
  pkg: 
    - installed
    - name: "{{ salt['pillar.get']('packages:neutron_l2_agent', default='neutron-plugin-openvswitch-agent') }}"
{% if bridges %}
    - require: 
{% for bridge in bridges %}
      - cmd: bridge-{{ bridge }}-create
{% endfor %}
{% endif %}


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
proxy-bridge-create-{{ bridge }}:
  cmd:
    - run
    - name: "ovs-vsctl add-br br-proxy"
    - unless: "ovs-vsctl br-exists br-proxy"
primary-nic-bring-up-{{ bridge }}:
  cmd:
    - run
    - name: "ip link set {{ salt['pillar.get']('neutron:single_nic') }} up promisc on"
    - require:
      - cmd: proxy-bridge-create-{{ bridge }}
{% if bridges[bridge] not in salt['network.interfaces']() %}
remove-fake-{{ bridges[bridge] }}-interfaces:
  cmd:
    - run
    - name: "ovs-vsctl del-port {{ bridges[bridge] }}"
    - onlyif: "ovs-vsctl list-ports {{ bridge }} | grep {{ bridges[bridge] }}"
    - require:
      - cmd: bridge-{{ bridge }}-create
remove-fake-{{ bridges[bridge] }}-br-proxy-interfaces:
  cmd:
    - run
    - name: "ovs-vsctl del-port {{ bridges[bridge] }}-br-proxy"
    - onlyif: "ovs-vsctl list-ports {{ bridge }} | grep {{ bridges[bridge] }}-br-proxy"
    - require:
      - cmd: bridge-{{ bridge }}-create
veth-add-{{ bridges[bridge] }}:
  cmd:
    - run
    - name: "ip link add {{ bridges[bridge] }} type veth peer name {{ bridges[bridge] }}-br-proxy"
    - require:
      - cmd: remove-fake-{{ bridges[bridge] }}-interfaces
      - cmd: remove-fake-{{ bridges[bridge] }}-br-proxy-interfaces
veth-bring-up-{{ bridges[bridge] }}-br-proxy:
  cmd:
    - run
    - name: "ip link set {{ bridges[bridge] }}-br-proxy up promisc on"
    - require:
      - cmd: veth-add-{{ bridges[bridge] }}
veth-add-{{ bridges[bridge] }}-br-proxy:
  cmd:
    - run
    - name: "ovs-vsctl add-port br-proxy {{ bridges[bridge] }}-br-proxy"
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
{{ bridges[bridge] }}-interface-bring-up:
  cmd:
    - run
    - name: "ip link set {{ bridges[bridge] }} up promisc on"
    - require:
      - cmd: {{ bridge }}-interface-add
{% endif %}
{% endfor %}
