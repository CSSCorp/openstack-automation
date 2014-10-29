juno: 
  "*.juno": 
    - cluster_resources
    - db_resources
    - access_resources
    - network_resources
    - openstack_cluster
  "os:{{ grains['os'] }}":
    - match: grain
    - "{{ grains['os'] }}"
