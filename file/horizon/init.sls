apache2: 
  pkg: 
    - installed
    - require: 
      - pkg: memcached
  service: 
    - running
    - watch: 
      - file: enable-dashboard
      - pkg: libapache2-mod-wsgi
enable-dashboard: 
  file: 
    - symlink
    - force: true
    - name: /etc/apache2/conf-enabled/openstack-dashboard.conf
    - target: /etc/apache2/conf-available/openstack-dashboard.conf
    - require: 
      - pkg: openstack-dashboard
libapache2-mod-wsgi: 
  pkg: 
    - installed
    - require: 
      - pkg: apache2
memcached: 
  pkg: 
    - installed
  service: 
    - running
    - watch: 
      - pkg: memcached
openstack-dashboard: 
  pkg: 
    - installed
    - require: 
      - pkg: apache2
