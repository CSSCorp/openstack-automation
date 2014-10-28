apache-install: 
  pkg: 
    - installed
    - name: {{ salt['pillar.get']('packages:apache', default='apache2') }}
    - require: 
      - pkg: memcached-install

apache-service:
  service: 
    - running
    - name: {{ salt['pillar.get']('services:apache', default='apache2') }}
    - watch: 
      - file: enable-dashboard
      - pkg: apache_wsgi_module

enable-dashboard: 
  file: 
    - symlink
    - force: true
    - name: "{{ salt['pillar.get']('conf_files:apache_dashboard_enabled_conf', default='/etc/apache2/conf-enabled/openstack-dashboard.conf') }}"
    - target: "{{ salt['pillar.get']('conf_files:apache_dashboard_conf', default='/etc/apache2/conf-available/openstack-dashboard.conf') }}"
    - require: 
      - pkg: openstack-dashboard-install

apache_wsgi_module: 
  pkg: 
    - installed
    - name: {{ salt['pillar.get']('packages:apache_wsgi_module', default='libapache2-mod-wsgi') }}
    - require: 
      - pkg: apache-install

memcached-install: 
  pkg: 
    - installed
    - name: {{ salt['pillar.get']('packages:memcached', default='memcached') }}

memcached-service:
  service: 
    - running
    - name: {{ salt['pillar.get']('services:memcached', default='memcached') }}
    - watch: 
      - pkg: memcached-install

openstack-dashboard-install: 
  pkg: 
    - installed
    - name: {{ salt['pillar.get']('packages:dashboard', default='openstack-dashboard') }}
    - require: 
      - pkg: apache-install
