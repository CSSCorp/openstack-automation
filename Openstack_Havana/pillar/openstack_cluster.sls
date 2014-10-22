cluster_entities: 
  - "compute"
  - "controller"
  - "network"
  - "storage-api"
  - "storage"
  - "image"
compute: 
  - "green"
  - "blue"
  - "orange"
  - "cyan"
  - "red"
controller: 
  - "brown"
image:
  - "brown"
network: 
  - "pink"
storage-api:
  - "pink"
storage:
  - "green"
cluster_name: "openstack_cluster"
keystone.auth_url: "http://brown:5000/v2.0/"
keystone.endpoint: "http://brown:35357/v2.0"
keystone.token: "24811ee3d9a09915bef0"
keystone.user: "admin"
keystone.password: "admin_pass"
keystone.tenant: "admin"
cluster_type: "openstack"
pkg_proxy_url: "http://mars:3142"
queue-engine: "rabbit"
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
keystone: 
  endpoint: "http://brown:35357/v2.0"
  token: "24811ee3d9a09915bef0"
  roles: 
    - "admin"
    - "Member"
  services: 
    glance: 
      service_type: "image"
      endpoint: 
        adminurl: "http://brown:9292"
        internalurl: "http://brown:9292"
        publicurl: "http://brown:9292"
      description: "glance image service"
    keystone: 
      service_type: "identity"
      endpoint: 
        adminurl: "http://brown:35357/v2.0"
        internalurl: "http://brown:5000/v2.0"
        publicurl: "http://brown:5000/v2.0"
      description: "Openstack Identity"
    neutron: 
      service_type: "network"
      endpoint: 
        adminurl: "http://pink:9696"
        internalurl: "http://pink:9696"
        publicurl: "http://pink:9696"
      description: "Openstack network service"
    nova: 
      service_type: "compute"
      endpoint: 
        adminurl: "http://brown:8774/v2/%(tenant_id)s"
        internalurl: "http://brown:8774/v2/%(tenant_id)s"
        publicurl: "http://brown:8774/v2/%(tenant_id)s"
      description: "nova compute service"
    cinder:
      service_type: "volume"
      endpoint:
        adminurl: "http://pink:8776/v1/%(tenant_id)s"
        internalurl: "http://pink:8776/v1/%(tenant_id)s"
        publicurl: "http://pink:8776/v1/%(tenant_id)s"
      description: "OpenStack Block Storage"
    cinderv2:
      service_type: "volumev2"
      endpoint:
        adminurl: "http://pink:8776/v2/%(tenant_id)s"
        internalurl: "http://pink:8776/v2/%(tenant_id)s"
        publicurl: "http://pink:8776/v2/%(tenant_id)s"
      description: "OpenStack Block Storage V2"
  tenants: 
    admin: 
      users: 
        admin: 
          password: "admin_pass"
          roles: "[\"admin\", \"_member_\"]"
          email: "salt@csscorp.com"
    service: 
      users: 
        cinder: 
          password: "cinder_pass"
          roles: "[\"admin\"]"
          email: "salt@csscorp.com"
        glance: 
          password: "glance_pass"
          roles: "[\"admin\"]"
          email: "salt@csscorp.com"
        neutron: 
          password: "neutron_pass"
          roles: "[\"admin\"]"
          email: "salt@csscorp.com"
        nova:
          password: "nova_pass"
          roles: "[\"admin\"]"
          email: "salt@csscorp.com"
  dbname: "keystone"
neutron: 
  intergration_bridge: br-int
  metadata_secret: "414c66b22b1e7a20cc35"
  tenant_network_types: 
    - "gre"
    - "flat"
  type_drivers: 
    flat: 
      pink: 
        External: 
          bridge: "br-ex"
          interface: "eth3"
    gre:
      tunnel_start: "1"
      tunnel_end: "1000"
install: 
  controller: 
    - "generics.host"
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
  image:
    - generics.host
    - glance
  network: 
    - "generics.host"
    - "mysql.client"
    - "neutron"
    - "neutron.service"
    - "neutron.openvswitch"
    - "neutron.ml2"
  compute: 
    - "generics.host"
    - "mysql.client"
    - "nova.compute_kvm"
    - "neutron.openvswitch"
    - "neutron.ml2"
  storage:
    - "cinder.volume"
  storage-api:
    - "cinder"
hosts: 
  red: 10.8.27.11
  green: 10.8.27.12
  blue: 10.8.27.7
  orange: 10.8.27.16
  brown: 10.8.27.17
  cyan: 10.8.27.22
  pink: 10.8.27.85
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


