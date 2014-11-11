roles: 
  - "controller"
  - "network"
  - "storage"
  - "compute"
compute: 
  - "openstack.icehouse"
controller: 
  - "openstack.icehouse"
network: 
  - "openstack.icehouse"
storage:
  - "openstack.icehouse"
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
    - "neutron.guest_mtu"
  compute: 
    - "mysql.client"
    - "nova.compute_kvm"
    - "neutron.openvswitch"
    - "neutron.ml2"
  storage:
    - "cinder.volume"
