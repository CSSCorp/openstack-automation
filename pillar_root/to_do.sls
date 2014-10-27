review glance half way through


enable distro support
define packages , services and config file locations in Ubuntu.sls
replace packages
replace services names
replace config file locations
replace require conditions


keystone.user: "admin"
keystone.password: "admin_pass"
keystone.tenant: "admin"
keystone.auth_url: "http://brown:5000/v2.0/"

Check if these are necessary for keystone state and module and add them if necessary






make changes to support 

openstack-services-sync: 
  glance: 
    db_sync: "glance-manage db_sync"
    db_name: "glance"
  nova: 
    db_name: "nova"
    db_sync: "nova-manage db sync"
  neutron: 
    db_name: "neutron"
  cinder:
    db_sync: "cinder-manage db sync"
    db_name: "cinder"
