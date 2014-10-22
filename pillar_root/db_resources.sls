mysql: 
  nova: 
    username: "nova"
    password: "nova_pass"
    service: "nova-api"
  dash: 
    username: "dash"
    password: "dash_pass"
  keystone: 
    username: "keystone"
    password: "keystone_pass"
    service: "keystone"
  cinder: 
    username: "cinder"
    password: "cinder_pass"
    service: "cinder"
  glance: 
    username: "glance"
    password: "glance_pass"
    service: "glance"
  neutron: 
    username: "neutron"
    password: "neutron_pass"
services: 
  keystone: 
    db_name: "keystone"
    db_sync: "keystone-manage db_sync"
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
