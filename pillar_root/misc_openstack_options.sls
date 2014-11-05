misc_options:
  neutron_dhcp_agent:
    sections:
      DEFAULT:
        debug: "True"
    service: neutron_dhcp_agent
    sls: neutron.service
    user: neutron
    group: neutron
    mode: '644'
  nova:
    sections:
      DEFAULT:
        libvirt_cpu_mode: host-passthrough
    service: nova_compute
    sls: nova_compute
    user: nova
    group: nova
    mode: '644'
