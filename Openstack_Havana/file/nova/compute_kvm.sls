nova-compute-kvm: 
    pkg: 
      - installed
  nova-compute: 
    pkg: 
      - installed
    service: 
      - running
      - watch: 
        - pkg: nova-compute
        - ini: nova-compute
        - ini: nova-conf
    file: 
      - managed
      - name: /etc/nova/nova-compute.conf
      - user: nova
      - group: nova
      - mode: 644
      - require: 
        - pkg: nova-compute
    ini: 
      - options_present
      - name: /etc/nova/nova-compute.conf
      - sections: 
          DEFAULT: 
{% if 'virt.is_hyper' in salt and salt['virt.is_hyper'] %}
    				libvirt_type: kvm
{% else %}
						libvirt_type: qemu
{% endif %}
      - require: 
        - file: nova-compute
  python-guestfs: 
    pkg: 
      - installed
  nova-conf: 
    file: 
      - managed
      - name: /etc/nova/nova.conf
      - user: nova
      - password: nova
      - mode: 644
      - require: 
           pkg: nova-compute
    ini: 
      - options_present
      - name: /etc/nova/nova.conf
      - sections: 
          DEFAULT: 
            vnc_enabled: True
            rabbit_host: {{ salt['cluster_ops.get_candidate']('queue.' + pillar['queue-engine']) }}
            my_ip: {{ grains['id'] }}
            vncserver_listen: 0.0.0.0
            glance_host: {{ salt['cluster_ops.get_candidate']('glance') }}
            vncserver_proxyclient_address: {{ grains['id'] }}
            rpc_backend: nova.rpc.impl_kombu
            novncproxy_base_url: http://{{ salt['cluster_ops.get_candidate']('nova') }}:6080/vnc_auto.html
            auth_strategy: keystone
            network_api_class: nova.network.neutronv2.api.API
            neutron_url: http://{{ salt['cluster_ops.get_candidate']('neutron') }}:9696
            neutron_auth_strategy: keystone
            neutron_admin_tenant_name: service
            neutron_admin_username: neutron
            neutron_admin_password: {{ pillar['keystone']['tenants']['service']['users']['neutron']['password'] }}
            neutron_admin_auth_url: http://{{ salt['cluster_ops.get_candidate']('keystone') }}:35357/v2.0
            linuxnet_interface_driver: nova.network.linux_net.LinuxOVSInterfaceDriver
            firewall_driver: nova.virt.firewall.NoopFirewallDriver
            security_group_api: neutron
            vif_plugging_is_fatal: False
            vif_plugging_timeout: 0
          keystone_authtoken: 
            auth_uri: {{ salt['cluster_ops.get_candidate']('keystone') }}:5000
            auth_port: 35357
            auth_protocol: http
            admin_tenant_name: service
            admin_user: nova
            admin_password: {{ pillar['keystone']['tenants']['service']['users']['nova']['password'] }}
            auth_host: {{ salt['cluster_ops.get_candidate']('keystone') }}
          database: 
            connection: mysql://{{ pillar['mysql'][pillar['services']['nova']['db_name']]['username'] }}:{{ pillar['mysql'][pillar['services']['nova']['db_name']]['password'] }}@{{ salt['cluster_ops.get_candidate']('mysql') }}/{{ pillar['services']['nova']['db_name'] }}
       - require: 
           file: nova-conf
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
        - pkg: nova-compute
