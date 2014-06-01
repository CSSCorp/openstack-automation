  glance: 
    pkg: 
      - installed
    service: 
      - running
      - names: 
          - glance-registry
          - glance-api
      - watch: 
          - pkg: glance
          - ini: glance-api-conf
          - ini: glance-registry-conf
  glance-api-conf: 
    file: 
      - managed
      - name: /etc/glance/glance-api.conf
      - mode: 644
      - user: glance
      - group: glance
      - require: 
          - pkg: glance
    ini: 
      - options_present
      - name: /etc/glance/glance-api.conf
      - sections: 
          database: 
            connection: mysql://{{ pillar['mysql'][pillar['services']['glance']['db_name']]['username'] }}:{{ pillar['mysql'][pillar['services']['glance']['db_name']]['password'] }}@{{ salt['cluster_ops.get_candidate']('mysql') }}/{{ pillar['services']['glance']['db_name'] }}
          DEFAULT: 
            rpc_backend: {{ pillar['queue-engine'] }}
            rabbit_host: {{ salt['cluster_ops.get_candidate']('queue.' + pillar['queue-engine']) }}
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
      - name: /etc/glance/glance-registry.conf
      - user: glance
      - group: glance
      - mode: 644
      - require: 
          - pkg: glance
    ini: 
      - options_present
      - name: /etc/glance/glance-registry.conf
      - sections: 
          database: 
            connection: mysql://{{ pillar['mysql'][pillar['services']['glance']['db_name']]['username'] }}:{{ pillar['mysql'][pillar['services']['glance']['db_name']]['password'] }}@{{ salt['cluster_ops.get_candidate']('mysql') }}/{{ pillar['services']['glance']['db_name'] }}
          DEFAULT: 
            rpc_backend: {{ pillar['queue-engine'] }}
            rabbit_host: {{ salt['cluster_ops.get_candidate']('queue.' + pillar['queue-engine']) }}
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
  glance_sync: 
    cmd: 
      - run
      - name: {{ pillar['services']['glance']['db_sync'] }}
      - require: 
          - service: glance
  glance_sqlite_delete: 
    file: 
      - absent
      - name: /var/lib/glance/glance.sqlite
      - require: 
          - pkg: glance
