{% from "cluster/resources.jinja" import get_candidate with context %}

nova-compute-kvm-install: 
  pkg: 
    - installed
    - name: {{ salt['pillar.get']('packages:nova_compute_kvm', default='nova-compute-kvm') }}

nova-compute-install:
  pkg: 
    - installed
    - name: {{ salt['pillar.get']('packages:nova_compute', default='nova-compute') }}

nova-compute-running:
  service: 
    - running
    - name: {{ salt['pillar.get']('services:nova_compute', default='nova-compute') }}
    - watch: 
      - pkg: nova-compute-install
      - file: nova-conf
      - ini: nova-conf
      - file: nova-compute-conf
      - ini: nova-compute-conf

nova-compute-conf:
  file: 
    - managed
    - name: {{ salt['pillar.get']('conf_files:nova_compute', default='/etc/nova/nova-compute.conf') }}
    - user: nova
    - group: nova
    - mode: 644
    - require: 
      - ini: nova-compute-conf
  ini: 
    - options_present
    - name: {{ salt['pillar.get']('conf_files:nova_compute', default='/etc/nova/nova-compute.conf') }}
    - sections: 
      DEFAULT: 
{% if 'virt.is_hyper' in salt and salt['virt.is_hyper'] %}
        libvirt_type: kvm
{% else %}
        libvirt_type: qemu
{% endif %}
    - require: 
      - pkg: nova-compute-install
      - pkg: nova-compute-kvm-install

python-guestfs-install: 
  pkg: 
    - installed
    - name: {{ salt['pillar.get']('packages:python_guestfs', default='python-guestfs') }}

nova-conf: 
  file: 
    - managed
    - name: {{ salt['pillar.get']('conf_files:nova', default='/etc/nova/nova.conf') }}
    - user: nova
    - password: nova
    - mode: 644
    - require: 
      - ini: nova-conf
  ini: 
    - options_present
    - name: {{ salt['pillar.get']('conf_files:nova', default='/etc/nova/nova.conf') }}
    - sections: 
        DEFAULT: 
          vnc_enabled: True
          rabbit_host: "{{ get_candidate('queue.%s' % salt['pillar.get']('queue_engine', default='rabbit')) }}"
          my_ip: {{ grains['id'] }}
          vncserver_listen: 0.0.0.0
          glance_host: {{ get_candidate('glance') }}
          vncserver_proxyclient_address: {{ grains['id'] }}
          rpc_backend: nova.rpc.impl_kombu
          novncproxy_base_url: http://{{ get_candidate('nova') }}:6080/vnc_auto.html
          auth_strategy: keystone
          network_api_class: nova.network.neutronv2.api.API
          neutron_url: http://{{ get_candidate('neutron') }}:9696
          neutron_auth_strategy: keystone
          neutron_admin_tenant_name: service
          neutron_admin_username: neutron
          neutron_admin_password: {{ pillar['keystone']['tenants']['service']['users']['neutron']['password'] }}
          neutron_admin_auth_url: http://{{ get_candidate('keystone') }}:35357/v2.0
          linuxnet_interface_driver: nova.network.linux_net.LinuxOVSInterfaceDriver
          firewall_driver: nova.virt.firewall.NoopFirewallDriver
          security_group_api: neutron
          vif_plugging_is_fatal: False
          vif_plugging_timeout: 0
        keystone_authtoken: 
          auth_uri: {{ get_candidate('keystone') }}:5000
          auth_port: 35357
          auth_protocol: http
          admin_tenant_name: service
          admin_user: nova
          admin_password: {{ pillar['keystone']['tenants']['service']['users']['nova']['password'] }}
          auth_host: {{ get_candidate('keystone') }}
        database: 
          connection: "mysql://{{ salt['pillar.get']('databases:nova:username', default='nova') }}:{{ salt['pillar.get']('databases:nova:password', default='nova_pass') }}@{{ get_candidate('mysql') }}/{{ salt['pillar.get']('databases:nova:db_name', default='nova') }}"
    - require: 
      - pkg: nova-compute-install
      - pkg: nova-compute-kvm-install

nova-instance-directory: 
  file: 
    - directory
    - name: /var/lib/nova/instances/
    - user: nova
    - group: nova
    - mode: 644
    - recurse: 
      - user
      - group
      - mode
    - require: 
      - pkg: nova-compute-install
      - pkg: nova-compute-kvm-install
