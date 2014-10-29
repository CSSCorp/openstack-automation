neutron_ml2:
  pkg:
    - installed
    - name: "{{ salt['pillar.get']('packages:neutron_ml2', default='neutron-plugin-ml2') }}"

{% set mappings = [] %}
{% for network_type in ('flat', 'vlan') %}
{% for physnet in salt['pillar.get']('neutron:type_drivers:%s:physnets' % network_type, default=()) %}
{% if grains['id'] in pillar['neutron']['type_drivers'][network_type]['physnets'][physnet]['hosts'] %}
{% do mappings.append(':'.join((physnet, pillar['neutron']['type_drivers'][network_type]['physnets'][physnet]['bridge'])) %}
{% endif %}
{% endfor %}
{% endfor %}



ml2_config_file:
  file:
    - managed
    - name: "{{ salt['pillar.get']('conf_files:neutron_ml2', default='/etc/neutron/plugins/ml2/ml2_conf.ini') }}"
    - user: neutron
    - group: neutron
    - mode: 644
    - require:
      - pkg: neutron_ml2
  ini:
    - options_present
    - name: "{{ salt['pillar.get']('conf_files:neutron_ml2', default='/etc/neutron/plugins/ml2/ml2_conf.ini') }}"
    - sections:
      ml2:
        type_drivers: "{{ ','.join(pillar['neutron']['type_drivers']) }}"
        tenant_network_types: "{{ ','.join(pillar['neutron']['type_drivers']) }}"
        mechanism_drivers: openvswitch
{% if 'flat' in pillar['neutron']['type_drivers'] %}
        ml2_type_flat:
          flat_networks: "{{ salt['cluster_ops.get_vlan_ranges']() }}"
{% endif %}
{% if 'vlan' in pillar['neutron']['type_drivers'] %}
        ml2_type_vlan: 
          network_vlan_ranges: "{{ salt['cluster_ops.get_vlan_ranges']('vlan') }}"
{% endif %}
{% if 'gre' in pillar['neutron']['type_drivers'] %}
        ml2_type_gre: 
          tunnel_id_ranges: "{{ pillar['neutron']['type_drivers']['gre']['tunnel_start'] }}:{{ pillar['neutron']['type_drivers']['gre']['tunnel_end'] }}"
{% endif %}
{% if 'vxlan' in pillar['neutron']['type_drivers'] %}
        ml2_type_vxlan:
          vni_ranges: "{{ pillar['neutron']['type_drivers']['gre']['tunnel_start'] }}:{{ pillar['neutron']['type_drivers']['gre']['tunnel_end'] }}"
{% endif %}
        ovs:
{% if 'flat' in pillar['neutron']['type_drivers'] or 'vlan' in pillar['neutron']['type_drivers'] %}
          bridge_mappings: "{{  ','.join(mappings)  }}"
{% endif %}
{% if 'gre' in pillar['neutron']['type_drivers'] %}
          tunnel_type: gre
          enable_tunneling: True
          local_ip: "{{ pillar['hosts'][grains['id']] }}"
{% endif %}
{% if 'vxlan' in pillar['neutron']['type_drivers'] %}
          tunnel_type: vxlan
          enable_tunneling: True
          local_ip: "{{ pillar['hosts'][grains['id']] }}"
{% endif %}
        securitygroup:
          firewall_driver: neutron.agent.linux.iptables_firewall.OVSHybridIptablesFirewallDriver
          enable_security_group: True
    - require:
      - file: ml2_config_file
