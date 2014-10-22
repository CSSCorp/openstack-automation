mysql-conf-file:
  file: 
    - managed
    - group: root
      mode: 644
      name: {{ salt['pillar.get']('conf_files:mysql', default='/etc/mysql/my.cnf') }}
      user: root
      require: 
        - pkg: mysql-server
  ini: 
    - options_present
    - name: {{ salt['pillar.get']('conf_files:mysql', default='/etc/mysql/my.cnf') }}
    - sections: 
        mysqld: 
          bind-address: 0.0.0.0
          character-set-server: utf8
          collation-server: utf8_general_ci
          init-connect: 'SET NAMES utf8'
    - require: 
        - file: mysql-conf-file

mysql-server-install: 
  pkg: 
    - installed
    - name: {{ salt['pillar.get']('packages:mysql-server', default='mysql-server') }}

mysql-service-running:
  service: 
    - running
    - name: {{ salt['pillar.get']('services:mysql', default='mysql') }}
    - watch: 
        - pkg: mysql-server-install
        - ini: mysql-conf-file

