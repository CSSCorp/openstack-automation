mysql-conf-file:
  file: 
    - managed
    - group: root
      mode: 644
      name: /etc/mysql/my.cnf
      user: root
      require: 
        - pkg: mysql-server
  ini: 
    - options_present
    - name: /etc/mysql/my.cnf
    - sections: 
        mysqld: 
          bind-address: 0.0.0.0
          character-set-server: utf8
          collation-server: utf8_general_ci
          init-connect: 'SET NAMES utf8'
    - require: 
        - file: mysql-conf-file
mysql-server: 
  pkg: 
    - installed
  service: 
    - running
    - name: mysql
    - watch: 
        - pkg: mysql-server
        - ini: mysql-conf-filea

