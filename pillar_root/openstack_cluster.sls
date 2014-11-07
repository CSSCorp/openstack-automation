
#queue backend 
queue_engine: rabbit

#db_backend
db_engine: mysql

#Point to the url where keystone would be installed
keystone.endpoint: "http://10.8.27.13:35357/v2.0"
keystone.admin_token: "24811ee3d9a09915bef0
keystone.user: "admin"
keystone.password: "admin_pass"
keystone.tenant: "admin"
keystone.auth_url: "http://10.8.27.13:5000/v2.0/"

#Uncomment below line if there is a valid package proxy
#pkg_proxy_url: "http://mars:3142"

#Data to identify cluster
cluster_type: icehouse

#Hosts and their ip addresses
hosts: 
  openstack.icehouse: 10.8.27.13


