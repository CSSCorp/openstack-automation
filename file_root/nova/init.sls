{% from "cluster/resources.jinja" import get_candidate with context %}

nova-api-install:
  pkg:
    - installed
    - name: "{{ salt['pillar.get']('packages:nova_api', default='nova-api') }}"

nova-api-running:
  service:
    - running
    - name: "{{ salt['pillar.get']('services:nova_api', default='nova-api') }}"
    - watch:
      - pkg: nova-api-install
      - ini: nova-conf
      - file: nova-conf

nova-conductor-install:
  pkg:
    - installed
    - name: "{{ salt['pillar.get']('packages:nova_conductor', default='nova-conductor') }}"

nova-conductor-running:
  service:
    - running
    - name: "{{ salt['pillar.get']('services:nova_conductor', default='nova-conductor') }}"
    - watch:
      - pkg: nova-conductor-install
      - ini: nova-conf
      - file: nova-conf

nova-scheduler-install:
  pkg:
    - installed
    - name: "{{ salt['pillar.get']('packages:nova_scheduler', default='nova-scheduler') }}"

nova-scheduler-running:
  service:
    - running
    - name: "{{ salt['pillar.get']('services:nova_scheduler', default='nova-scheduler') }}"
    - watch:
      - pkg: nova-scheduler-install
      - ini: nova-conf
      - file: nova-conf

nova-cert-install:
  pkg:
    - installed
    - name: "{{ salt['pillar.get']('packages:nova_cert', default='nova-cert') }}"

nova-cert-running:
  service:
    - running
    - name: "{{ salt['pillar.get']('services:nova_cert', default='nova-cert') }}"
    - watch:
      - pkg: nova-cert-install
      - ini: nova-conf
      - file: nova-conf

nova-consoleauth-install:
  pkg:
    - installed
    - name: "{{ salt['pillar.get']('packages:nova_consoleauth', default='nova-consoleauth') }}"

nova-consoleauth-running:
  service:
    - running
    - name: "{{ salt['pillar.get']('services:nova_consoleauth', default='nova-consoleauth') }}"
    - watch:
      - pkg: nova-consoleauth-install
      - ini: nova-conf
      - file: nova-conf

python-novaclient:
  pkg:
    - installed
    - name: "{{ salt['pillar.get']('packages:nova_pythonclient', default='python-novaclient') }}"

nova-ajax-console-proxy:
  pkg:
    - installed
    - name: "{{ salt['pillar.get']('packages:nova_ajax_console_proxy', default='nova-ajax-console-proxy') }}"

novnc:
  pkg:
    - installed
    - name: "{{ salt['pillar.get']('packages:novnc', default='novnc') }}"

nova-novncproxy-install:
  pkg:
    - installed
    - name: "{{ salt['pillar.get']('packages:nova_novncproxy', default='nova-novncproxy') }}"

nova-novncproxy-running:
  service:
    - running
    - name: "{{ salt['pillar.get']('services:nova_novncproxy', default='nova-novncproxy') }}"
    - watch:
      - pkg: nova-novncproxy-install
      - ini: nova-conf
      - file: nova-conf

{% if 'db_sync' in salt['pillar.get']('databases:nova', default=()) %}
nova_sync: 
  cmd: 
    - run
    - name: "{{ salt['pillar.get']('databases:nova:db_sync') }}"
    - require: 
        - service: nova-api-running
{% endif %}

nova_sqlite_delete:
  file:
    - absent
    - name: /var/lib/nova/nova.sqlite
    - require:
      - pkg: nova-api

nova-conf:
  file:
    - managed
    - name: "{{ salt['pillar.get']('conf_files:nova', default='/etc/nova/nova.conf') }}"
    - user: nova
    - group: nova
    - mode: 644
    - require:
      - pkg: nova-api
      - ini: nova-conf
  ini:
    - options_present
    - name: "{{ salt['pillar.get']('conf_files:nova', default='/etc/nova/nova.conf') }}"
    - sections: 
        DEFAULT: 
          auth_strategy: "keystone"
          rabbit_host: "{{ get_candidate('queue.%s' % salt['pillar.get']('queue_engine', default='rabbit')) }}"
          my_ip: "{{ grains['id'] }}"
          vncserver_listen: "{{ get_candidate('nova') }}"
          vncserver_proxyclient_address: "{{ get_candidate('nova') }}"
          rpc_backend: "{{ pillar['queue_engine'] }}"
          network_api_class: "nova.network.neutronv2.api.API"
          neutron_url: "http://{{ get_candidate('neutron') }}:9696"
          neutron_auth_strategy: "keystone"
          neutron_admin_tenant_name: "service"
          neutron_admin_username: "neutron"
          neutron_admin_password: "{{ pillar['keystone']['tenants']['service']['users']['neutron']['password'] }}"
          neutron_admin_auth_url: "http://{{ get_candidate('keystone') }}:35357/v2.0"
          linuxnet_interface_driver: "nova.network.linux_net.LinuxOVSInterfaceDriver"
          firewall_driver: "nova.virt.firewall.NoopFirewallDriver"
          security_group_api: "neutron"
          service_neutron_metadata_proxy: "True"
          neutron_metadata_proxy_shared_secret: "{{ pillar['neutron']['metadata_secret'] }}"
          vif_plugging_is_fatal: "False"
          vif_plugging_timeout: "0"
        keystone_authtoken: 
          auth_protocol: "http"
          admin_user: "nova"
          admin_password: "{{ pillar['keystone']['tenants']['service']['users']['nova']['password'] }}"
          auth_host: "{{ get_candidate('keystone') }}"
          auth_uri: "http://{{ get_candidate('keystone') }}:5000"
          admin_tenant_name: "service"
          auth_port: "35357"
        database: 
          connection: "mysql://{{ salt['pillar.get']('databases:nova:username', default='nova') }}:{{ salt['pillar.get']('databases:nova:password', default='nova_pass') }}@{{ get_candidate('mysql') }}/{{ salt['pillar.get']('databases:nova:db_name', default='nova') }}"
    - require:
      - pkg: nova-api-install
