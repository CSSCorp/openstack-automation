juno: 
  "*.juno": 
    - cluster_resources
    - db_resources
    - access_resources
    - network_resources
    - openstack_cluster
    - deploy_files
  "os:{{ grains['os'] }}":
    - match: grain
    - "{{ grains['os'] }}"
    - "{{ grains['os'] }}_repo"
