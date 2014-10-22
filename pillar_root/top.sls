juno: 
  "*.juno": 
    - cluster_resources
    - db_resources
    - access_resources
    - openstack_cluster
  "os:{{ grains['os_family'] }}":
    - match: grain
    - "{{ grains['os_family'] }}"
