{% from "cluster/resources.jinja" import get_candidate with context %}
neutron-dhcp-agent-install: 
  pkg: 
    - installed
    - name: "{{ salt['pillar.get']('packages:neutron_dhcp_agent', default='neutron-dhcp-agent') }}"

neutron-dhcp-agent-running:
  service: 
    - running
    - name: "{{ salt['pillar.get']('services:neutron_dhcp_agent', default='neutron-dhcp-agent') }}"
    - watch: 
      - pkg: neutron-dhcp-agent-install
      - ini: neutron-dhcp-agent-config
      - file: neutron-dhcp-agent-config
      - ini: neutron-service-neutron-conf
      - file: neutron-service-neutron-conf

neutron-dhcp-agent-config:
  file: 
    - managed
    - name: "{{ salt['pillar.get']('conf_files:neutron_dhcp_agent', default='/etc/neutron/dhcp_agent.ini') }}"
    - user: neutron
    - group: neutron
    - mode: 644
    - require: 
      - ini: neutron-dhcp-agent-config
  ini: 
    - options_present
    - name: "{{ salt['pillar.get']('conf_files:neutron_dhcp_agent', default='/etc/neutron/dhcp_agent.ini') }}"
    - sections: 
        DEFAULT: 
          dhcp_driver: neutron.agent.linux.dhcp.Dnsmasq
          interface_driver: neutron.agent.linux.interface.OVSInterfaceDriver
          use_namespaces: True
    - require: 
      - pkg: neutron-dhcp-agent-install


neutron-metadata-agent-install: 
  pkg: 
    - installed
    - name: "{{ salt['pillar.get']('packages:neutron_metadata_agent', default='neutron-metadata-agent') }}"

neutron-metadata-agent-running:
  service: 
    - running
    - name: "{{ salt['pillar.get']('services:neutron_metadata_agent', default='neutron-metadata-agent') }}"
    - watch: 
      - pkg: neutron-metadata-agent-install
      - file: neutron-metadata-agent-conf
      - ini: neutron-metadata-agent-conf
      - ini: neutron-service-neutron-conf
      - file: neutron-service-neutron-conf

neutron-metadata-agent-conf:
  file: 
    - managed
    - name: "{{ salt['pillar.get']('conf_files:neutron_metadata_agent', default='/etc/neutron/metadata_agent.ini') }}"
    - user: neutron
    - group: neutron
    - mode: 644
    - require: 
      - ini: neutron-metadata-agent-conf
  ini: 
    - options_present
    - name: "{{ salt['pillar.get']('conf_files:neutron_metadata_agent', default='/etc/neutron/metadata_agent.ini') }}"
    - sections: 
        DEFAULT: 
          admin_tenant_name: service
          auth_region: RegionOne
          admin_user: neutron
          auth_url: "http://{{ get_candidate('keystone') }}:5000/v2.0"
          admin_password: "{{ pillar['keystone']['tenants']['service']['users']['neutron']['password'] }}"
          metadata_proxy_shared_secret: "{{ pillar['neutron']['metadata_secret'] }}"
          nova_metadata_ip: "{{ get_candidate('nova') }}"
    - require: 
      - pkg: neutron-metadata-agent-install

neutron-l3-agent-install: 
  pkg: 
    - installed
    - name: "{{ salt['pillar.get']('packages:neutron_l3_agent', default='neutron-l3-agent') }}"

neutron-l3-agent-running:
  service: 
    - running
    - name: "{{ salt['pillar.get']('services:neutron_l3_agent', default='neutron-l3-agent') }}"
    - watch: 
      - pkg: neutron-l3-agent
      - ini: neutron-l3-agent-config
      - file: neutron-l3-agent-config
      - ini: neutron-service-neutron-conf
      - file: neutron-service-neutron-conf

neutron-l3-agent-config:
  file: 
    - managed
    - name: "{{ salt['pillar.get']('conf_files:neutron_l3_agent', default='/etc/neutron/l3_agent.ini') }}"
    - user: neutron
    - group: neutron
    - mode: 644
    - require: 
      - ini: neutron-l3-agent-config
  ini: 
    - options_present
    - name: "{{ salt['pillar.get']('conf_files:neutron_l3_agent', default='/etc/neutron/l3_agent.ini') }}"
    - sections: 
        DEFAULT: 
          interface_driver: neutron.agent.linux.interface.OVSInterfaceDriver
          use_namespaces: True
    - require: 
      - pkg: neutron-l3-agent-install

enable_forwarding: 
  file: 
    - managed
    - name: "{{ salt['pillar.get']('conf_files:syslinux', default='/etc/sysctl.conf' ) }}"
  ini: 
    - options_present
    - name: "{{ salt['pillar.get']('conf_files:syslinux', default='/etc/sysctl.conf' ) }}"
    - sections: 
        DEFAULT_IMPLICIT: 
          net.ipv4.conf.all.rp_filter: 0
          net.ipv4.ip_forward: 1
          net.ipv4.conf.default.rp_filter: 0


networking-service: 
  service: 
    - running
    - name: "{{ salt['pillar.get']('conf_files:networking', default='networking') }}"
    - watch: 
      - file: enable_forwarding
      - ini: enable_forwarding

neutron-service-neutron-conf:
  file: 
    - managed
    - name: "{{ salt['pillar.get']('conf_files:neutron_l3_agent', default='/etc/neutron/l3_agent.ini') }}"
    - user: neutron
    - group: neutron
    - mode: 644
    - require: 
      - ini: neutron-service-neutron-conf
  ini: 
    - options_present
    - name: "{{ salt['pillar.get']('conf_files:neutron', default='/etc/neutron/neutron.conf') }}"
    - sections: 
        DEFAULT: 
          rabbit_host: "{{ get_candidate('queue.%s' % salt['pillar.get']('queue_engine', default='rabbit')) }}"
          auth_strategy: keystone
          rpc_backend: neutron.openstack.common.rpc.impl_kombu
          core_plugin: ml2
          service_plugins: router
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
      - pkg: neutron-metadata-agent-install
      - pkg: neutron-dhcp-agent-install
      - pkg: neutron-l3-agent-install
