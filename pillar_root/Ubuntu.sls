packages:
  mysql-client: mysql-client
  python-mysql-library: python-mysqldb
  mysql-server: mysql-server
  rabbitmq: rabbitmq-server
  keystone: keystone
  glance: glance
services:
  mysql: mysql
  rabbitmq: rabbitmq
  keystone: keystone
  glance_api: glance-api
  glance_registry: glance-registry
conf_files:
  mysql: "/etc/mysql/my.cnf"
  keystone: "/etc/keystone/keystone.conf"
  glance_api: "/etc/glance/glance-api.conf"
  glance_registry: "/etc/glance/glance-registry.conf"
  
