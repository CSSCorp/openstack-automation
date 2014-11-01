This project is under development. Please do not use this. Check this section soon for a stable release.

openstack-automation
====================

Openstack deployment using saltstack

There are several methods for automated deployment of openstack cluster. In this project we attempt to do it using [saltstack](http://docs.saltstack.com/ "Saltstack"). There is almost no coding involved and it can be easily maintained. Above all it is as easy as talking to your servers and asking them to configure themselves. 

Saltstack provides us an infrastructure management framework that makes our job easier. Saltstack supports most of tasks that you would want to perform while installing openstack and more. We might not need any programming to do so. All we do need to do is define our cluster as below.

<pre>
cluster_entities: 
  - "compute"
  - "controller"
  - "network"
  - "storage"
compute: 
  - "compute1.juno"
  - "compute2.juno"
controller: 
  - "controller.juno"
network: 
  - "network.juno"
storage:
  - "storage1.juno"
  - "storage2.juno"
</pre>

What we saw above is the [pillar](http://docs.saltstack.com/topics/pillar/ "Salt Pillar") definition. Should you need to change your cluster definition you do so by changing the pillar and synchronising the changes. Although this file defines your cluster entirely the file in itself can do nothing. The entire project has been checked in [here](https://github.com/Akilesh1597/openstack-automation/ "Openstack-Automation").

Please go through [salt walkthrough](http://docs.saltstack.com/en/latest/topics/tutorials/walkthrough.html "walkthrough") to understand how salt works. When you are ready to install openstack modify the [salt-master configuration](http://docs.saltstack.com/en/latest/ref/configuration/master.html "salt-master configuration") file at "/etc/salt/master" to hold the below contents.

<pre>
fileserver_backend:
  - roots
  - git
gitfs_remotes:
  - https://github.com/Akilesh1597/salt-openstack.git
  - root: file_root
ext_pillar:
  - git: juno https://github.com/Akilesh1597/salt-openstack.git root=pillar_root
jinja_trim_blocks: True
jinja_lstrip_blocks: True
</pre>
This will create a new [environment](http://docs.saltstack.com/ref/file_server/index.html#environments "Salt Environments") called "juno" in your state tree. The 'file_roots' directory of the github repo will have [state definitions](http://docs.saltstack.com/topics/tutorials/starting_states.html "Salt States") in a bunch of '.sls' files and the few special directories, while the 'pillar_root' directory has your cluster definition files. 

At this stage I assume that you have two machines 'controller.juno', 'network.juno', 'storage.juno', 'compute1.juno' and 'compute2.juno' (these are their hostnames as well as their minion id) added to the salt master. See [setting up salt minion](http://docs.saltstack.com/topics/tutorials/walkthrough.html#setting-up-a-salt-minion "minion setup") to add minions to the master. The pillar definition file shown at the begining has a key 'openstack_version=juno'. We will use this key to deliver commands to these machines alone like so.

<pre>
salt '*' saltutil.refresh_pillar
salt '*' saltutil.sync_all
salt -C 'I@openstack_version:juno' state.highstate
</pre>


This instructs all the minions those who have 'openstack_version=juno' defined in their pillar data to download all the state defined for them and execute the same. If all goes well you can login to your newly installed openstack setup 'http://controller.juno/horizon'.


Cluster Definition
==================

To make things clear lets have a look at a part of the pillar configuration. Our 'pillar_root' defines a 'top.sls' file with following contents.

<pre>
juno: 
  "*.juno": 
    - cluster_resources
    - db_resources
    - access_resources
    - openstack_cluster
  "os:{{ grains['os_family'] }}":
    - match: grain
    - "{{ grains['os_family'] }}"
</pre>

This in turn instructs all minions with ids matching the regular expression '*.juno' to use 'cluster_resources', 'db_references', 'access_resources' and 'openstack_cluster' as their pillar source. Each of these files has a set of configurations for the cluster to be deployed.

cluster_resources
=================
Defines the 'cluster entities'(the entities that form the cluster), the hosts that perform the roles defined by these entities, and finally the formulas(sls files) that would define each of the entity. Below the excerpt.

<pre>
cluster_entities: 
  - "compute"
  - "controller"
  - "network"
  - "storage"
compute: 
  - "compute1.juno"
  - "compute2.juno"
controller: 
  - "controller.juno"
network: 
  - "network.juno"
storage:
  - "storage1.juno"
  - "storage2.juno"
sls: 
  controller: 
    - "generics.host"
    - "mysql"
    - "mysql.client"
    - "mysql.openstack_dbschema"
    - "queue.rabbit"
    - "keystone"
    - "keystone.openstack_tenants"
    - "keystone.openstack_users"
    - "keystone.openstack_services"
    - "nova"
    - "horizon"
    - "glance"
    - "cinder"
  network: 
    - "generics.host"
    - "mysql.client"
    - "neutron"
    - "neutron.service"
    - "neutron.openvswitch"
    - "neutron.ml2"
  compute: 
    - "generics.host"
    - "mysql.client"
    - "nova.compute_kvm"
    - "neutron.openvswitch"
    - "neutron.ml2"
  storage:
    - "cinder.volume"
</pre>


Adding a new cluster entity
===========================

Lets say we move the queue server as a new entity. This is how we do it.
1. Add a new entitiy "queue_server" under "cluster_entities"
2. Define what minions will perform the role of "queue_server"
3. Finally define which formula deploys a "queue_server" under the "install"."queue_server" section.
<pre>
cluster_entities: 
  - "compute"
  - "controller"
  - "network"
  - "storage"
  - "queue_server"
compute: 
  - "compute1.juno"
  - "compute2.juno"
controller: 
  - "controller.juno"
network: 
  - "network.juno"
storage:
  - "storage1.juno"
  - "storage2.juno"
queue_server:
  - "queueserver.juno"
sls: 
  queue_server:
    - "queue.rabbit"
  controller: 
    - "generics.host"
    - "mysql"
    - "mysql.client"
    - "mysql.openstack_dbschema"
    - "keystone"
    - "keystone.openstack_tenants"
    - "keystone.openstack_users"
    - "keystone.openstack_services"
    - "nova"
    - "horizon"
    - "glance"
    - "cinder"
  network: 
    - "generics.host"
    - "mysql.client"
    - "neutron"
    - "neutron.service"
    - "neutron.openvswitch"
    - "neutron.ml2"
  compute: 
    - "generics.host"
    - "mysql.client"
    - "nova.compute_kvm"
    - "neutron.openvswitch"
    - "neutron.ml2"
  storage:
    - "cinder.volume"
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
compute: 
  - "compute1.juno"
  - "compute2.juno"
  - "compute3.juno"
</pre>

Then sync up the cluster as shown below.

<pre>
salt '*' saltutil.sync_all
salt '*' saltutil.refresh_pillar
salt -C 'I@cluster_type:openstack' state.highstate
</pre>

db_resources
============
Defines the databases that need to be created, along with the users and their passwords.

access_resources
================
Defines the openstack authentication parameters, which include keystone tenants, users, their passwords, services and their endpoints.

openstack_cluster
=================
Defines some general configuration for the cluster to be deployed. For example "pkg_proxy_url" defines the proxy server to be used to download packages. Do not define this parameter if you do not use any proxy. The hosts section defines the list of hosts on which the installation is to be carried on and their ip addresses. The presence of this section ensures that these hosts are configured in the "known hosts" file on the servers. Finally you also define the "queue" and "database" backend.


network_resources
=================
Defines configuration that define the openstack ["Data" and "External" networks](http://fosskb.wordpress.com/2014/06/10/managing-openstack-internaldataexternal-network-in-one-interface/ "Openstack networking"). The default configuration will install a "gre" mode "Data" network and a "flat" mode "External" network, and looks as below.

<pre>
neutron: 
  intergration_bridge: br-int
  metadata_secret: "414c66b22b1e7a20cc35"
  type_drivers: 
    flat: 
      physnets: 
        External: 
          bridge: "br-ex"
          hosts:
            network.juno: "eth3"
    gre:
      tunnel_start: "1"
      tunnel_end: "1000"
</pre>

Choosing the vxlan mode is not difficult either.
<pre>
neutron: 
  intergration_bridge: br-int
  metadata_secret: "414c66b22b1e7a20cc35"
  type_drivers: 
    flat: 
      physnets: 
        External: 
          bridge: "br-ex"
          hosts:
            network.juno: "eth3"
    vxlan:
      tunnel_start: "1"
      tunnel_end: "1000"
</pre>

For vlan mode tenant networks, you need to add 'vlan' under 'tenant_network_types' and for each compute host and network host specify the list of [physical networks](http://fosskb.wordpress.com/2014/06/19/l2-connectivity-in-openstack-using-openvswitch-mechanism-driver/ "Openstack physical networks") and their corresponding bridge, interface and allowed vlan range.

<pre>
neutron: 
  intergration_bridge: br-int
  metadata_secret: "414c66b22b1e7a20cc35"
  type_drivers: 
    flat: 
      physnets: 
        External: 
          bridge: "br-ex"
          hosts:
            network.juno: "eth3"
    vlan: 
      physnets: 
        Internal1: 
          bridge: "br-eth1"
          vlan_range: "100:200"
          hosts:
            network.juno: "eth2"
            compute1.juno: "eth2"
            compute2.juno: "eth2"
        Internal2:
          bridge: "br-eth2"
          vlan_range: "200:300"
          hosts:
            network.juno: "eth4"
            compute3.juno: "eth2"
</pre>
