packages:
  mysql-client: mysql-client
  python-mysql-library: python-mysqldb
  mysql-server: mysql-server
  rabbitmq: rabbitmq-server
  keystone: keystone
services:
  mysql: mysql
  rabbitmq: rabbitmq
  keystone: keystone
conf_files:
  mysql: "/etc/mysql/my.cnf"
  keystone: "/etc/keystone/keystone.conf"
  
