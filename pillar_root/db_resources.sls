databases: 
  nova: 
    db_name: "nova"
    username: "nova"
    password: "nova_pass"
    service: "nova-api"
    db_sync: "nova-manage db sync"
  keystone: 
    db_name: "keystone"
    username: "keystone"
    password: "keystone_pass"
    service: "keystone"
    db_sync: "keystone-manage db_sync"
  cinder: 
    db_name: "cinder"
    username: "cinder"
    password: "cinder_pass"
    service: "cinder"
    db_sync: "cinder-manage db sync"
  glance: 
    db_name: "glance"
    username: "glance"
    password: "glance_pass"
    service: "glance"
    db_sync: "glance-manage db_sync"
  neutron: 
    db_name: "neutron"
    username: "neutron"
    password: "neutron_pass"
