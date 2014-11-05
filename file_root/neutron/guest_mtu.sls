neutron-dhcp-agent-running-mtu:
  service: 
    - running
    - name: "{{ salt['pillar.get']('services:neutron_dhcp_agent', default='neutron-dhcp-agent') }}"
    - watch: 
      - ini: neutron-dhcp-agent-config-mtu
      - file: neutron-dhcp-agent-config-mtu
      - ini: dnsmasq-conf
      - file: dnsmasq-conf

neutron-dhcp-agent-config-mtu:
  file: 
    - managed
    - name: "{{ salt['pillar.get']('conf_files:neutron_dhcp_agent', default='/etc/neutron/dhcp_agent.ini') }}"
    - user: neutron
    - group: neutron
    - mode: 644
    - require: 
      - ini: neutron-dhcp-agent-config-mtu
  ini: 
    - options_present
    - name: "{{ salt['pillar.get']('conf_files:neutron_dhcp_agent', default='/etc/neutron/dhcp_agent.ini') }}"
    - sections: 
        DEFAULT: 
          dnsmasq_config_file = "/etc/neutron/dnsmasq-neutron.conf"

dnsmasq-conf:
  file:
    - managed
    - name: "/etc/neutron/dnsmasq-neutron.conf"
    - user: neutron
    - group: neutron
    - mode: 644
    - require: 
      - ini: dnsmasq-conf
  ini: 
    - options_present
    - name: "/etc/neutron/dnsmasq-neutron.conf"
    - sections: 
        DEFAULT: 
          dhcp-options-force: "26,1454"
    - require: 
      - ini: neutron-dhcp-agent-config-mtu
