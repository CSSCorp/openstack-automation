glance-pkg-install: 
  pkg: 
    - installed
    - name: {{ salt['pillar.get']('packages:glance', default='glance') }}


glace_registry_running:
  service: 
    - running
    - name: {{ salt['pillar.get']('services:glance_registry') }}
      - watch: 
          - pkg: glance-pkg-install
          - ini: glance-api-conf
          - ini: glance-registry-conf

glance_api_running:
  service:
    - running
    - name: {{ salt['pillar.get']('services:glance_api') }}
      - watch: 
          - pkg: glance-pkg-install
          - ini: glance-api-conf
          - ini: glance-registry-conf

glance-api-conf: 
  file: 
    - managed
    - name: {{ salt['pillar.get']('conf_files:glance_api', default="/etc/glance/glance-api.conf") }}
    - mode: 644
    - user: glance
    - group: glance
    - require: 
        - pkg: glance-pkg-install
  ini: 
    - options_present
    - name: {{ salt['pillar.get']('conf_files:glance_api', default="/etc/glance/glance-api.conf") }}
    - sections: 
        database: 
          connection: mysql://{{ salt['pillar.get']('databases:glance:username', default='glance') }}:{{ salt['pillar.get']('databases:glance:password', default='glance_pass') }}@{{ salt['cluster_ops.get_candidate']('mysql') }}/{{ salt['pillar.get']('databases:glance:db_name', default='glance') }}
        DEFAULT: 
          rpc_backend: {{ pillar['queue-engine'] }}
          rabbit_host: {{ salt['cluster_ops.get_candidate']('queue.*') }}
        keystone_authtoken: 
          auth_uri: http://{{ salt['cluster_ops.get_candidate']('keystone') }}:5000
          auth_port: 35357
          auth_protocol: http
          admin_tenant_name: service
          admin_user: glance
          admin_password: {{ pillar['keystone']['tenants']['service']['users']['glance']['password'] }}
          auth_host: {{ salt['cluster_ops.get_candidate']('keystone') }}
        paste_deploy: 
          flavor: keystone
    - require: 
        - file: glance-api-conf

glance-registry-conf: 
  file: 
    - managed
    - name: {{ salt['pillar.get']('conf_files:glance_registry', default="/etc/glance/glance-registry.conf") }}
    - user: glance
    - group: glance
    - mode: 644
    - require: 
        - pkg: glance-pkg-install
  ini: 
    - options_present
    - name: {{ salt['pillar.get']('conf_files:glance_registry', default="/etc/glance/glance-registry.conf") }}
    - sections: 
        database: 
          connection: mysql://{{ salt['pillar.get']('databases:glance:username', default='glance') }}:{{ salt['pillar.get']('databases:glance:password', default='glance_pass') }}@{{ salt['cluster_ops.get_candidate']('mysql') }}/{{ salt['pillar.get']('databases:glance:db_name', default='glance') }}
        DEFAULT: 
          rpc_backend: {{ pillar['queue-engine'] }}
          rabbit_host: {{ salt['cluster_ops.get_candidate']('queue.*') }}
        keystone_authtoken: 
          auth_uri: http://{{ salt['cluster_ops.get_candidate']('keystone') }}:5000
          auth_port: 35357
          auth_protocol: http
          admin_tenant_name: service
          admin_user: glance
          admin_password: {{ pillar['keystone']['tenants']['service']['users']['glance']['password'] }}
          auth_host: {{ salt['cluster_ops.get_candidate']('keystone') }}
        paste_deploy: 
          flavor: keystone
    - require: 
        - file: glance-registry-conf

{% if 'db_sync' in salt['pillar.get']('databases:glance', default=()) %}
glance_sync: 
  cmd: 
    - run
    - name: {{ salt['pillar.get']('databases:glance:db_sync') }}
    - require: 
        - service: glance
{% endif %}

glance_sqlite_delete: 
  file: 
    - absent
    - name: /var/lib/glance/glance.sqlite
    - require: 
        - pkg: glance
