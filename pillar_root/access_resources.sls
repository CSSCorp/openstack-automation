keystone: 
  admin_token: "24811ee3d9a09915bef0" 
  roles: 
    - "admin"
    - "Member"
  services: 
    glance: 
      service_type: "image"
      endpoint: 
        adminurl: "http://{{ salt['cluster_ops.get_candidate']('glance') }}:9292"
        internalurl: "http://{{ salt['cluster_ops.get_candidate']('glance') }}:9292"
        publicurl: "http://{{ salt['cluster_ops.get_candidate']('glance') }}:9292"
      description: "glance image service"
    keystone: 
      service_type: "identity"
      endpoint: 
        adminurl: "http://{{ salt['cluster_ops.get_candidate']('keystone') }}:35357/v2.0"
        internalurl: "http://{{ salt['cluster_ops.get_candidate']('keystone') }}:5000/v2.0"
        publicurl: "http://{{ salt['cluster_ops.get_candidate']('keystone') }}:5000/v2.0"
      description: "Openstack Identity"
    neutron: 
      service_type: "network"
      endpoint: 
        adminurl: "http://{{ salt['cluster_ops.get_candidate']('neutron') }}:9696"
        internalurl: "http://{{ salt['cluster_ops.get_candidate']('neutron') }}:9696"
        publicurl: "http://{{ salt['cluster_ops.get_candidate']('neutron') }}:9696"
      description: "Openstack network service"
    nova: 
      service_type: "compute"
      endpoint: 
        adminurl: "http://{{ salt['cluster_ops.get_candidate']('nova') }}:8774/v2/%(tenant_id)s"
        internalurl: "http://{{ salt['cluster_ops.get_candidate']('nova') }}:8774/v2/%(tenant_id)s"
        publicurl: "http://{{ salt['cluster_ops.get_candidate']('nova') }}:8774/v2/%(tenant_id)s"
      description: "nova compute service"
    cinder:
      service_type: "volume"
      endpoint:
        adminurl: "http://{{ salt['cluster_ops.get_candidate']('cinder') }}:8776/v1/%(tenant_id)s"
        internalurl: "http://{{ salt['cluster_ops.get_candidate']('cinder') }}:8776/v1/%(tenant_id)s"
        publicurl: "http://{{ salt['cluster_ops.get_candidate']('cinder') }}:8776/v1/%(tenant_id)s"
      description: "OpenStack Block Storage"
    cinderv2:
      service_type: "volumev2"
      endpoint:
        adminurl: "http://{{ salt['cluster_ops.get_candidate']('cinder') }}:8776/v2/%(tenant_id)s"
        internalurl: "http://{{ salt['cluster_ops.get_candidate']('cinder') }}:8776/v2/%(tenant_id)s"
        publicurl: "http://{{ salt['cluster_ops.get_candidate']('cinder') }}:8776/v2/%(tenant_id)s"
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
