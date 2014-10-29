neutron: 
  intergration_bridge: br-int
  metadata_secret: "414c66b22b1e7a20cc35"
  tenant_network_types: 
    - "gre"
    - "flat"
    - "vlan"
  type_drivers: 
    flat: 
      physnets: 
        External: 
          bridge: "br-ex"
          hosts:
            openstack.juno: "eth3"
    vlan: 
      physnets: 
        Internal1: 
          bridge: "br-eth1"
          vlan_range: "100:200"
          hosts:
            openstack.juno: "eth2"
    gre:
      tunnel_start: "1"
      tunnel_end: "1000"





