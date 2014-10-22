file_root/mysql/openstack_dbschema.sls:6:{% for cluster_component in pillar['install'] %}
file_root/_modules/cluster_ops.py:20:        for sls in __pillar__.get('install', {}).get(role, []):


rename 'install' to 'sls' as per pillar definition



file_root/cinder/volume.sls:47:          rabbit_host: {{ salt['cluster_ops.get_candidate']('queue.' + pillar['queue-engine']) }}
file_root/cinder/init.sls:30:          rabbit_host: {{ salt['cluster_ops.get_candidate']('queue.' + pillar['queue-engine']) }}
file_root/nova/compute_kvm.sls:51:            rabbit_host: {{ salt['cluster_ops.get_candidate']('queue.' + pillar['queue-engine']) }}
file_root/nova/init.sls:78:	        rabbit_host: "{{ salt['cluster_ops.get_candidate']('queue.' + pillar['queue-engine']) }}"
file_root/nova/init.sls:82:	        rpc_backend: "{{ pillar['queue-engine'] }}"
file_root/neutron/service.sls:106:          rabbit_host: {{ salt['cluster_ops.get_candidate']('queue.' + pillar['queue-engine']) }}
file_root/neutron/openvswitch.sls:33:          rabbit_host: {{ salt['cluster_ops.get_candidate']('queue.' + pillar['queue-engine']) }}
file_root/neutron/init.sls:23:          rabbit_host: {{ salt['cluster_ops.get_candidate']('queue.' + pillar['queue-engine']) }}
file_root/glance/init.sls:29:            rpc_backend: {{ pillar['queue-engine'] }}
file_root/glance/init.sls:30:            rabbit_host: {{ salt['cluster_ops.get_candidate']('queue.' + pillar['queue-engine']) }}
file_root/glance/init.sls:59:            rpc_backend: {{ pillar['queue-engine'] }}
file_root/glance/init.sls:60:            rabbit_host: {{ salt['cluster_ops.get_candidate']('queue.' + pillar['queue-engine']) }}



get_candidate to be modified to accomodate queue.* syntax



keystone.user: "admin"
keystone.password: "admin_pass"
keystone.tenant: "admin"
keystone.auth_url: "http://brown:5000/v2.0/"

Check if these are necessary for keystone state and module and add them if necessary


