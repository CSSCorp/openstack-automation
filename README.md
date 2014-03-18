openstack-automation
====================

Openstack deployment using saltstack

There are several methods for automated deployment of openstack cluster. In this blog we attempt to do it using [saltstack](http://docs.saltstack.com/ "Saltstack"). There is almost no coding involved and it can be easily maintained. Above all it is as easy as talking to your servers and asking them to configure themselves. 

Saltstack provides us an infrastructure management framework that makes our job easier. Saltstack supports most of tasks that you would want to perform while installing openstack and more. We might not need any programming to do so. All we do need to do is define our cluster as below.

<pre>
{
	"cluster_entities": [
		"compute",
		"controller",
		"network"
	],
    "compute": [
        "venus"
    ],
    "controller": [
        "mercury"
    ], 
    "network": [
		"mercury"
    ],
    "neutron": {
		"metadata_secret": "414c66b22b1e7a20cc35",
		"intergration_bridge": "br-int",
		"network_mode": "vlan",
		"venus": {
			"Intnet1": {
				"start_vlan": "100",
				"end_vlan": "200",
				"bridge": "br-eth1",
				"interface": "eth1"
			}
		},
		"mercury": {
			"Intnet1": {
				"start_vlan": "100",
				"end_vlan": "200",
				"bridge": "br-eth1",
				"interface": "eth1"
			},
			"Extnet": {
				"bridge": "br-ex",
				"interface": "eth2"
			}
		}
    },
    "install": {
        "controller": [
            "generics.havana_cloud_repo", 
            "generics.apt-proxy", 
            "generics.headers",
            "generics.host",
            "mysql",
            "mysql.client",
            "mysql.openstack_dbschema",
            "queue.rabbit",
            "keystone",
            "keystone.openstack_tenants",
            "keystone.openstack_users",
            "keystone.openstack_services",
            "glance",
            "nova",
            "horizon"
        ], 
        "network": [
            "generics.havana_cloud_repo", 
            "generics.apt-proxy", 
            "generics.headers",
            "generics.host",
            "neutron",
            "neutron.openvswitch"
        ],
        "compute": [
            "generics.havana_cloud_repo", 
            "generics.apt-proxy", 
            "generics.headers",
            "generics.host",
            "nova.compute_kvm",
            "neutron.openvswitch"
        ]
    },
    "hosts": {
		"mercury": "mercury_ip_here",
		"venus": "venus_ip_here",
		"saturn": "saturn_ip_here",
		"salt": "sat_master_ip_here"
    }
}
</pre>

What we saw above is the [pillar](http://docs.saltstack.com/topics/pillar/ "Salt Pillar") definition. Should you need to change your cluster definition you do so by changing the pillar and synchronising the changes. Although this file defines your cluster entirely the file in itself can do nothing. The entire project has been checked in [here](https://github.com/Akilesh1597/openstack-automation/ "Openstack-Automation").

To test it create a new [environment](http://docs.saltstack.com/ref/file_server/index.html#environments "Salt Environments") in your salt master configuration file and point it to where you have downloaded the project like so.

<pre>

file_roots: 
  base: 
    - /srv/salt/ 
  havana: 
    - (project-directory)/file 
pillar_roots: 
  base: 
    - /srv/pillar 
  havana: 
    - (project-directory)/pillar 

</pre>

This will add the havana environment to your saltstack. The 'file_roots' will have [state definitions](http://docs.saltstack.com/topics/tutorials/starting_states.html "Salt States") in a bunch of '.sls' files and the few special directories, while the 'pillar_roots' has your cluster definition. 

At this stage I assume that you have two machines 'mercury' and 'venus' (these are their hostnames as well as their minion id) added to the salt master. See [setting up salt minion](http://docs.saltstack.com/topics/tutorials/walkthrough.html#setting-up-a-salt-minion "minion setup") to add minions to the master. The pillar definition file shown at the begining has a key 'cluster_type'. We will use this key to deliver commands to the two machines alone like so.

<pre>
salt '*' saltutil.sync_all
salt '*' saltutil.refresh_pillar
salt -C 'I@cluster_type:openstack' state.highstate
</pre>


This instructs all the minions those who have 'cluster_type=openstack' defined in their pillar data to download all the state defined for them and execute the same. If all goes well you can login to your newly installed openstack setup 'http://mercury/horizon'.


Note
====
The state generics.apt-proxy installs a file at /etc/apt/apt.conf.d/01proxy. This points to your salt master as [apt cache proxy](https://help.ubuntu.com/community/Apt-Cacher-Server "Apt Cache"). If you do not want this to happen delete the file '/etc/apt/apt.conf.d/01proxy' and remove the formula "generics.apt-proxy" from your pillar config file.


Cluster Definition
==================

To make things clear lets have a look at a part of the pillar configuration.

<pre>
    "cluster_entities": [
		"compute",
		"controller",
		"network"
	],
    "compute": [
        "venus"
    ],
    "controller": [
        "mercury"
    ], 
    "network": [
	"mercury"
    ],
    "install": {
        "controller": [
            "generics.havana_cloud_repo", 
            "generics.apt-proxy", 
            "generics.headers",
            "generics.host",
            "mysql",
            "mysql.client",
            "mysql.openstack_dbschema",
            "queue.rabbit",
            "keystone",
            "keystone.openstack_tenants",
            "keystone.openstack_users",
            "keystone.openstack_services",
            "glance",
            "nova",
            "horizon"
        ], 
        "network": [
            "generics.havana_cloud_repo", 
            "generics.apt-proxy", 
            "generics.headers",
            "generics.host",
            "neutron",
            "neutron.openvswitch"
        ],
        "compute": [
            "generics.havana_cloud_repo", 
            "generics.apt-proxy", 
            "generics.headers",
            "generics.host",
            "nova.compute_kvm",
            "neutron.openvswitch"
        ]
    }
</pre>

This "cluster_entities" defines what are the entities that form the cluster. The controller node, network node and compute node form the entities of an openstack cluster.

Then we define which machine performs the role of each of the defined entities.

Finally the “install” section defines what formulas to apply on a machine in order to deploy each of the entities.



Adding a new cluster entity
===========================

Lets say we need add a new entity called queue_server which will run rabbitmq. This is how we do it.
1. Add a new entitiy "queue_server" under "cluster_entities"
2. Define what minions will perform the role of "queue_server"
3. Finally define which formula deploys a "queue_server" under the "install"."queue_server" section.
<pre>
    "cluster_entities": [
	"compute",
	"controller",
	"network",
	"queue_server"
	],
    "compute": [
        "venus"
    ],
    "controller": [
        "mercury"
    ], 
    "network": [
	"mercury"
    ],
    "queue_server": [
    	"jupiter"
    ],
    "install": {
        "controller": [
            "generics.havana_cloud_repo", 
            "generics.apt-proxy", 
            "generics.headers",
            "generics.host",
            "mysql",
            "mysql.client",
            "mysql.openstack_dbschema",
            "keystone",
            "keystone.openstack_tenants",
            "keystone.openstack_users",
            "keystone.openstack_services",
            "glance",
            "nova",
            "horizon"
        ], 
        "network": [
            "generics.havana_cloud_repo", 
            "generics.apt-proxy", 
            "generics.headers",
            "generics.host",
            "neutron",
            "neutron.openvswitch"
        ],
        "compute": [
            "generics.havana_cloud_repo", 
            "generics.apt-proxy", 
            "generics.headers",
            "generics.host",
            "nova.compute_kvm",
            "neutron.openvswitch"
        ],
        "queue_server": [
            "queue.rabbit"
        ]
    }
</pre>

Then edit your 'pillar/top.sls' and point jupiter to use 'openstack_cluster.sls'

<pre>
havana:
  mercury: [openstack_cluster]
  venus: [openstack_cluster]
  jupiter: [openstack_cluster]
</pre>

Then sync up the cluster as shown below.

<pre>
salt '*' saltutil.sync_all
salt '*' saltutil.refresh_pillar
salt -C 'I@cluster_type:openstack' state.highstate
</pre>


Adding new compute node
=======================

Adding a new machine to a cluster is as easy as editing a json file. All you have to do is edit 'pillar/openstack_cluster.sls' as below.

<pre>
"compute": [
        "venus",
        "saturn"
    ]
</pre>

Then edit your 'pillar/top.sls' and point saturn to use 'openstack_cluster.sls'

<pre>
havana:
  mercury: [openstack_cluster]
  venus: [openstack_cluster]
  jupiter: [openstack_cluster]
  saturn: [openstack_cluster]
</pre>

Then sync up the cluster as shown below.

<pre>
salt '*' saltutil.sync_all
salt '*' saltutil.refresh_pillar
salt -C 'I@cluster_type:openstack' state.highstate
</pre>


OVS Vlan mode networking
========================

The default configuration will install a vlan mode network. Have a close look at the configuration.

<pre>
    "neutron": {
	"metadata_secret": "414c66b22b1e7a20cc35",
	"intergration_bridge": "br-int",
	"network_mode": "vlan",
	"venus": {
		"Intnet1": {
			"start_vlan": "100",
			"end_vlan": "200",
			"bridge": "br-eth1",
			"interface": "eth1"
		}
	},
	"mercury": {
		"Intnet1": {
			"start_vlan": "100",
			"end_vlan": "200",
			"bridge": "br-eth1",
			"interface": "eth1"
		},
		"Extnet": {
			"bridge": "br-ex",
			"interface": "eth2"
		}
	}
    }
</pre>
For each node "venus", "mercury" etc you specify the physical_networks, the start and end vlan id in that physnet, the bridge that is connected to the physnet and the interface that should be present in the brdige. For flat network do not provide any start and end vlan. 


OVS GRE mode networking
=======================

If GRE mode networking is desired please alter the pillar file as below.

<pre>
    "neutron": {
	"metadata_secret": "414c66b22b1e7a20cc35",
	"intergration_bridge": "br-int",
	"network_mode": "tunnel",
	"tunnel_start": "100",
	"tunnel_end": "200",
	"tunnel_type": "gre"
    }
</pre>


OVS VXLAN mode networking
=========================

If GRE mode networking is desired please alter the pillar file as below.

<pre>
    "neutron": {
	"metadata_secret": "414c66b22b1e7a20cc35",
	"intergration_bridge": "br-int",
	"network_mode": "tunnel",
	"tunnel_start": "100",
	"tunnel_end": "200",
	"tunnel_type": "vxlan"
    }
</pre>




Removing a node
===============

Change the file 'pillar_root/top.sls' from 

<pre>
havana:
  hawk:
    - openstack_cluster
  lammer:
    - openstack_cluster
</pre>
to
<pre>
havana:
  hawk:
    - openstack_cluster_inverse
  lammer:
    - openstack_cluster_inverse
</pre>

Then sync up the cluster as always.

<pre>
salt '*' saltutil.sync_all
salt -C 'I@cluster_type:openstack' state.highstate
</pre>

Note
====
This is not tested completely and it will remove only the packages from the hosts. Detaching the host from openstack controller is still a manual task. 
