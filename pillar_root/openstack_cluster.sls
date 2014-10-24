keystone.endpoint: "{{ salt['pillar.get']('keystone:services:keystone:endpoint:admin_url') }}"
keystone.token: "{{ salt['pillar.get']('keystone:admin_token') }}"
pkg_proxy_url: "http://mars:3142"
cluster_type: juno
hosts: 
  red: 10.8.27.11
  green: 10.8.27.12
  blue: 10.8.27.7
  orange: 10.8.27.16
  brown: 10.8.27.17
  cyan: 10.8.27.22
  pink: 10.8.27.85


