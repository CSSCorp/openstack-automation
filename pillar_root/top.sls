juno: 
  "*.juno": 
    - openstack_cluster
  "os:{{ grains['os_family'] }}":
    - "{{ grains['os_family'] }}"
