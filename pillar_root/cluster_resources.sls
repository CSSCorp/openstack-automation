cluster_entities: 
  - "compute"
  - "controller"
  - "network"
  - "storage"
compute: 
  - "openstack.juno"
controller: 
  - "openstack.juno"
network: 
  - "openstack.juno"
storage:
  - "openstack.juno"
sls: 
  controller: 
    - "mysql"
    - "mysql.client"
    - "mysql.openstack_dbschema"
    - "queue.rabbit"
    - "keystone"
    - "keystone.openstack_tenants"
    - "keystone.openstack_users"
    - "keystone.openstack_services"
    - "nova"
    - "horizon"
    - "glance"
    - "cinder"
  network: 
    - "mysql.client"
    - "neutron"
    - "neutron.service"
    - "neutron.openvswitch"
    - "neutron.ml2"
  compute: 
    - "mysql.client"
    - "nova.compute_kvm"
    - "neutron.openvswitch"
    - "neutron.ml2"
  storage:
    - "cinder.volume"
