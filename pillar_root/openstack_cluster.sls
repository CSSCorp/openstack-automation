
#queue backend 
queue_engine: rabbit

#db_backend
db_engine: mysql

#Point to the url where keystone would be installed
keystone.endpoint: "http://192.168.20.4:35357/v2.0"
keystone.token: "24811ee3d9a09915bef0"

#Uncomment below line if there is a valid package proxy
#pkg_proxy_url: "http://mars:3142"

#Data to identify cluster
cluster_type: juno

#Hosts and their ip addresses
hosts: 
  openstack.juno: 192.168.20.4


