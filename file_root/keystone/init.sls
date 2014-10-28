keystone-pkg-install: 
  pkg: 
    - installed
    - name: {{ salt['pillar.get']('packages:keystone', default='keystone') }}

keystone-service-running:
  service: 
    - running
    - name: {{ salt['pillar.get']('services:keystone', default='keystone') }}
    - watch: 
        - pkg: keystone-pkg-install
        - ini: keystone-conf-file

keystone-conf-file:
    file: 
      - managed
      - name: {{ salt['pillar.get']('conf_files:keystone', default='/etc/keystone/keystone.conf') }}
      - user: root
      - group: root
      - mode: 644
      - require: 
          - pkg: keystone-pkg-install
    ini: 
      - options_present
      - name: {{ salt['pillar.get']('conf_files:keystone', default='/etc/keystone/keystone.conf') }}
      - sections: 
          DEFAULT: 
            admin_token: {{ salt['pillar.get']('keystone.admin_token', default='ADMIN') }}
          sql: 
            connection: mysql://{{ salt['pillar.get']('databases:keystone:username', default='keystone') }}:{{ salt['pillar.get']('databases:keystone:password', default='keystone_pass') }}@{{ salt['cluster_ops.get_candidate']('mysql') }}/{{ salt['pillar.get']('databases:keystone:db_name', default='keystone') }}
      - require: 
          - file: keystone-conf-file

{% if 'db_sync' in salt['pillar.get']('databases:keystone', default=()) %}
keystone_sync: 
  cmd: 
    - run
    - name: {{ salt['pillar.get']('databases:keystone:db_sync') }}
    - require: 
        - service: keystone
{% endif %}

keystone_sqlite_delete: 
  file: 
    - absent
    - name: /var/lib/keystone/keystone.sqlite
    - require: 
      - pkg: keystone-pkg-install
