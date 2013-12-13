openstack-automation
====================

Openstack deployment using saltstack

There are several methods for automated deployment of openstack cluster. In this blog we attempt to do it using [saltstack](http://docs.saltstack.com/ "Saltstack"). There is almost no coding involved and it can be easily maintained. Above all it is as easy as talking to your servers and asking them to configure themselves. 

Saltstack provides us an infrastructure management framework that makes our job easier. Saltstack supports most of tasks that you would want to perform while installing openstack and more. We might not need any programming to do so. All we do need to do is define our cluster as below.

<pre>
{
    "controller": [
        "hawk"
    ],
    "compute": [
        "lammer"
    ],
    "install": {
        "controller": [
            "generics.host",
            "generics.havana",
            "generics.ntp",
            "mysql",
            "queue.rabbit",
            "keystone",
            "glance",
            "nova",
            "mysql.client",
            "horizon",
            "neutron",
            "neutron.openvswitch"
        ],
        "compute": [
            "generics.host",
            "generics.havana",
            "generics.ntp",
            "mysql.client",
            "nova.compute_kvm",
            "neutron.openvswitch"
        ]
    },
    "salt-master": "<salt master ip address here>",
    "cluster_type": "openstack",
    "config-folder": "cluster1",
    "keystone.token": "24811ee3f7f09915bef0",
    "keystone.endpoint": "http://hawk:35357/v2.0",
    "keystone": {
        "token": "24811ee3f7f09915bef0",
        "endpoint": "http://hawk:35357/v2.0",
        "dbname": "keystone",
        "tenants": {
            "admin": {
                "users": {
                    "admin": {
                        "password": "admin_pass",
                        "email": "salt@csscorp.com",
                        "role": "admin"
                    }
                }
            },
            "service": {
                "users": {
                    "glance": {
                        "password": "glance_pass",
                        "email": "salt@csscorp.com",
                        "role": "admin"
                    },
                    "nova": {
                        "password": "nova_pass",
                        "email": "salt@csscorp.com",
                        "role": "admin"
                    },
                    "cinder": {
                        "password": "cinder_pass",
                        "email": "salt@csscorp.com",
                        "role": "admin"
                    },
                    "neutron": {
                        "password": "neutron_pass",
                        "email": "salt@csscorp.com",
                        "role": "admin"
                    }
                }
            }
        },
        "roles": [
            "admin",
            "Member"
        ],
        "services": {
            "keystone": {
                "service_type": "identity",
                "description": "keystone identity service",
                "endpoint": {
                    "publicurl": "http://{{ grains['id'] }}:5000/v2.0",
                    "internalurl": "http://{{ grains['id'] }}:5000/v2.0",
                    "adminurl": "http://{{ grains['id'] }}:35357/v2.0"
                }
            },
            "glance": {
                "service_type": "image",
                "description": "glance image service",
                "endpoint": {
                    "publicurl": "http://{{ grains['id'] }}:9292",
                    "internalurl": "http://{{ grains['id'] }}:9292",
                    "adminurl": "http://{{ grains['id'] }}:9292"
                }
            },
            "nova": {
                "service_type": "compute",
                "description": "nova compute service",
                "endpoint": {
                    "publicurl": "http://{{ grains['id'] }}:8774/v2/%(tenant_id)s",
                    "internalurl": "http://{{ grains['id'] }}:8774/v2/%(tenant_id)s",
                    "adminurl": "http://{{ grains['id'] }}:8774/v2/%(tenant_id)s"
                }
            },
            "cinder": {
                "service_type": "volume",
                "description": "cinder volume service",
                "endpoint": {
                    "publicurl": "http://{{ grains['id'] }}:8776/v1/%(tenant_id)s",
                    "internalurl": "http://{{ grains['id'] }}:8776/v1/%(tenant_id)s",
                    "adminurl": "http://{{ grains['id'] }}:8776/v1/%(tenant_id)s"
                }
            },
            "neutron": {
                "service_type": "network",
                "description": "Openstack network service",
                "endpoint": {
                    "publicurl": "http://{{ grains['id'] }}:9696",
                    "internalurl": "http://{{ grains['id'] }}:9696",
                    "adminurl": "http://{{ grains['id'] }}:9696"
                }
            }
        }
    },
    "mysql": {
        "keystone": {
            "username": "keystone",
            "password": "keystone_pass",
            "sync": "keystone-manage db_sync",
            "service": "keystone"
        },
        "glance": {
            "username": "glance",
            "password": "glance_pass",
            "sync": "glance-manage db_sync",
            "service": "glance"
        },
        "cinder": {
            "username": "cinder",
            "password": "cinder_pass"
        },
        "nova": {
            "username": "nova",
            "password": "nova_pass",
            "sync": "nova-manage db sync",
            "service": "nova-api"
        },
        "neutron": {
            "username": "neutron",
            "password": "neutron_pass"
        },
        "dash": {
            "username": "dash",
            "password": "dash_pass"
        }
    },
    "DM": {
        "cpu": {
            "threshold": 70
        },
        "memory": {
            "threshold": 70
        },
        "swap": {
            "threshold": 70
        }
    },
    "hosts": {
        "hawk": "<hawk ip address here>",
        "lammer": "<lammer ip address here>"
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

At this stage I assume that you have two machines 'hawk' and 'lammer' (these are their hostnames as well as their minion id). The pillar definition file shown at the begining has a key 'cluster_type'. We will use this key to deliver commands to the two machines alone like so.

<pre>
salt -C 'I@cluster_type:openstack' state.highstate
</pre>


This instructs all the minions those who have 'cluster_type=openstack' defined in their pillar data to download all the state defined for them and execute the same. Once the command is run once you will note that several states have failed. Not to worry. Run the command again. You will note that each time you run will bring your cluster closer to completion. At third run you will have all your states applied successfully. At this stage you can login to your newly installed openstack setup 'http://hawk/horizon'.

The states have done almost all the stuff for you. You still have to follow [neutron deployment use cases](http://docs.openstack.org/trunk/install-guide/install/apt/content/neutron-deploy-use-cases.html "Networking Options") to have your network up and running. This involves creation of your intergration bridge, external bridge, physical networks etc.

To make things clear lets have a look at a part of the pillar configuration.

<pre>
    "controller": [
        "hawk"
    ],
    "compute": [
        "lammer"
    ],
    "install": {
        "controller": [
            "generics.host",
            "generics.havana",
            "generics.ntp",
            "mysql",
            "queue.rabbit",
            "keystone",
            "glance",
            "nova",
            "mysql.client",
            "horizon",
            "neutron",
            "neutron.openvswitch"
        ],
        "compute": [
            "generics.host",
            "generics.havana",
            "generics.ntp",
            "mysql.client",
            "nova.compute_kvm",
            "neutron.openvswitch"
        ]
    },
    "config-folder": "cluster1",
</pre>

First define one controller node, which is 'hawk', and one compute node 'lammer'. 

Under the “install” section we define what states to apply on a machine in order to deploy a controller or a compute node.

The “config-folder” options tells the minions where to get their configuration files from. Setting it to 'cluster1' will tell the minions to get their configuration files from 'file_roots/config/cluster1/'. These have been used extensively in state definitions.

The rest of the pillar definition is self explanatory.


Adding new compute node
=======================

Follow the below steps to have a new compute node in your cluster

1. Add a new machine to salt-master.
2. Add it under the list of compute nodes like so
<pre>    
"compute": [
         "lammer",
     	 "goshawk"
    ]
</pre>
3. Under 'file_root/config/cluster1/' add a new directory named 'goshawk'. Copy all the files from 'file_root/config/cluster1/lammer/' into 'file_root/config/cluster1/goshawk'.
4. Run the below command to modify configuration files according to new compute node hostname
<code>
find file_root/config/cluster1/goshawk -type f -name \*.\* -exec sed -i 's/lammer/goshawk/' {} \;
</code>
5. Finally sync the cluster
<pre>
salt -C 'I@cluster_type:openstack' state.highstate
</pre>

The above methodology can be used to perform auto scaling, which off course is the next project.

Removing a node
===============

Change the file 'pillar_root/top.sls' from 

<pre>
havana:
  hawk:
    - cluster1
  lammer:
    - cluster1
</pre>
to
<pre>
havana:
  hawk:
    - cluster1_inverse
  lammer:
    - cluster1_inverse
</pre>

Now run 
<pre>
salt (machine id here) state.highstate
</pre>
