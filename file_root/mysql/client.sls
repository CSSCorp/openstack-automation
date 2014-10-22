mysql-client-install: 
  pkg: 
    - installed
    - name: {{ salt['pillar.get']('packages:mysql-client', default='mysql-client') }}
python-mysql-library-install: 
  pkg: 
    - installed
    - require: 
        - pkg: {{ salt['pillar.get']('packages:python-mysql-library', default='python-mysqldb') }}
