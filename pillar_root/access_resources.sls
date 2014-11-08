keystone: 
  admin_token: "24811ee3d9a09915bef0"
  roles: 
    - "admin"
    - "Member"
  services: 
    glance: 
      service_type: "image"
      endpoint: 
        adminurl: "http://{0}:9292"
        internalurl: "http://{0}:9292"
        publicurl: "http://{0}:9292"
        endpoint_host_sls: glance
      description: "glance image service"
    keystone: 
      service_type: "identity"
      endpoint: 
        adminurl: "http://{0}:35357/v2.0"
        internalurl: "http://{0}:5000/v2.0"
        publicurl: "http://{0}:5000/v2.0"
        endpoint_host_sls: keystone
      description: "Openstack Identity"
    neutron: 
      service_type: "network"
      endpoint: 
        adminurl: "http://{0}:9696"
        internalurl: "http://{0}:9696"
        publicurl: "http://{0}:9696"
        endpoint_host_sls: neutron
      description: "Openstack network service"
    nova: 
      service_type: "compute"
      endpoint: 
        adminurl: "http://{0}:8774/v2/%(tenant_id)s"
        internalurl: "http://{0}:8774/v2/%(tenant_id)s"
        publicurl: "http://{0}:8774/v2/%(tenant_id)s"
        endpoint_host_sls: nova
      description: "nova compute service"
    cinder:
      service_type: "volume"
      endpoint:
        adminurl: "http://{0}:8776/v1/%(tenant_id)s"
        internalurl: "http://{0}:8776/v1/%(tenant_id)s"
        publicurl: "http://{0}:8776/v1/%(tenant_id)s"
        endpoint_host_sls: cinder
      description: "OpenStack Block Storage"
    cinderv2:
      service_type: "volumev2"
      endpoint:
        adminurl: "http://{0}:8776/v2/%(tenant_id)s"
        internalurl: "http://{0}:8776/v2/%(tenant_id)s"
        publicurl: "http://{0}:8776/v2/%(tenant_id)s"
        endpoint_host_sls: cinder
      description: "OpenStack Block Storage V2"
  tenants: 
    admin: 
      users: 
        admin: 
          password: "admin_pass"
          roles: "[\"admin\", \"_member_\"]"
          email: "salt@openstack.com"
    service: 
      users: 
        cinder: 
          password: "cinder_pass"
          roles: "[\"admin\"]"
          email: "salt@openstack.com"
        glance: 
          password: "glance_pass"
          roles: "[\"admin\"]"
          email: "salt@openstack.com"
        neutron: 
          password: "neutron_pass"
          roles: "[\"admin\"]"
          email: "salt@openstack.com"
        nova:
          password: "nova_pass"
          roles: "[\"admin\"]"
          email: "salt@openstack.com"
