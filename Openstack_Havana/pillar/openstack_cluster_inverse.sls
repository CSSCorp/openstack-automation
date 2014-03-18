#!jinja|json
{
	"cluster_entities": [
		"compute",
		"controller",
		"network"
	],
    "compute": [
        "saturn"
    ],
    "controller": [
        "mercury"
    ], 
    "network": [
		"mercury"
    ],
    "cluster_name": "openstack_cluster",
    "keystone.auth_url": "http://mercury:5000/v2.0/", 
    "keystone.endpoint": "http://mercury:35357/v2.0", 
    "keystone.token": "24811ee3d9a09915bef0",
    "keystone.user": "admin",
    "keystone.password": "admin_pass",
    "keystone.tenant": "admin",
    "cluster_type": "openstack", 
    "pkg_proxy_url": "http://salt:3142",
    "queue-engine": "queue.rabbit",
    "cloud_repos": [
		{
			"reponame": "havana-cloud-bin",
			"name": "deb http://ubuntu-cloud.archive.canonical.com/ubuntu precise-updates/havana main",
			"file": "/etc/apt/sources.list.d/cloudarchive-havana.list"
		},
		{
			"reponame": "havana-cloud-src",
			"name": "deb-src http://ubuntu-cloud.archive.canonical.com/ubuntu precise-updates/havana main",
			"file": "/etc/apt/sources.list.d/cloudarchive-havana-src.list"
		}
	],
    "install": {
        "controller": [
            "inverse.generics.havana_cloud_repo", 
            "inverse.generics.apt-proxy", 
            "inverse.generics.headers",
            "inverse.generics.host",
            "inverse.mysql",
            "inverse.mysql.client",
            "inverse.queue.rabbit",
            "inverse.keystone",
            "inverse.glance",
            "inverse.nova",
            "inverse.horizon"
        ],
        "network": [
            "inverse.generics.havana_cloud_repo", 
            "inverse.generics.apt-proxy", 
            "inverse.generics.headers",
            "inverse.generics.host",
            "inverse.neutron",
            "inverse.neutron.openvswitch"
        ],
        "compute": [
            "inverse.generics.havana_cloud_repo", 
            "inverse.generics.apt-proxy", 
            "inverse.generics.headers",
            "inverse.generics.host",
            "inverse.nova.compute_kvm",
            "inverse.neutron.openvswitch"
        ]
    }
}
