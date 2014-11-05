mysql-client-install: 
  pkg: 
    - installed
    - name: {{ salt['pillar.get']('packages:mysql-client', default='mysql-client') }}
python-mysql-library-install: 
  pkg: 
    - installed
    - name: {{ salt['pillar.get']('packages:python-mysql-library', default='python-mysqldb') }}
    - require: 
        - pkg: mysql-client-install
