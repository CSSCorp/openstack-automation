What is New
===========
1. Branches icehouse and icehouse will alone exist and continue forward
2. Repo modified to be used as git fileserver backend. User may use 'git_pillar' pointed to 'pillar_root' sub directory or download the files to use in 'roots' backend.
3. Pull request to the project has some regulations, documented towards the end of the README.
4. 'yaml' will be default format for sls files. This is done as maintaining sls files across format is causing mismatches and errors. Further 'json' does not go well with 'jinja' templating(formulas end up less readable).
5. 'cluster_ops' salt module has been removed. Its functionality has been achieved using 'jinja macros', in an attempt to remove any dependencies that are not available in saltstack's list of modules.
6. Support for cinder added. Check 'Cinder Volume' section of README.
7. Support for all linux distros added. Check 'Packages, Services, Config files and Repositories section' of README.
8. Partial support for 'single server single nic' installations. Check section 'Single Interface Scenario' for details.
9. Pillar data has been segregated in multiple files according to its purpose.
<pre>
---------------------------------------------------------------------------------
|Pillar File		| Purpose						|
---------------------------------------------------------------------------------
|openstack_cluster	| Generic cluster Data					| 
|access_resources	| Keystone tenants, users, roles, services and endpoints|
|cluster_resources	| Hosts, Roles and their correspoinding formulas	|
|db_resources		| Databases, Users, Passwords and Grants		|
|deploy_files		| Arbitrary files to be deployed on all minions		|
|misc_openstack_options	| Arbitrary openstack options and affected services	|
|<DISTRO>.sls		| Distro specific package data				|
|<DISTRO>_repo.sls	| Distro specific repository data			|
---------------------------------------------------------------------------------
</pre>

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
  - "compute1.icehouse"
  - "compute2.icehouse"
controller: 
  - "controller.icehouse"
network: 
  - "network.icehouse"
storage:
  - "storage1.icehouse"
  - "storage2.icehouse"
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
  - git: icehouse https://github.com/Akilesh1597/salt-openstack.git root=pillar_root
jinja_trim_blocks: True
jinja_lstrip_blocks: True
</pre>
This will create a new [environment](http://docs.saltstack.com/ref/file_server/index.html#environments "Salt Environments") called "icehouse" in your state tree. The 'file_roots' directory of the github repo will have [state definitions](http://docs.saltstack.com/topics/tutorials/starting_states.html "Salt States") in a bunch of '.sls' files and the few special directories, while the 'pillar_root' directory has your cluster definition files. 

At this stage I assume that you have two machines 'controller.icehouse', 'network.icehouse', 'storage.icehouse', 'compute1.icehouse' and 'compute2.icehouse' (these are their hostnames as well as their minion id) added to the salt master. See [setting up salt minion](http://docs.saltstack.com/topics/tutorials/walkthrough.html#setting-up-a-salt-minion "minion setup") to add minions to the master. The pillar definition file shown at the begining has a key 'openstack_version=icehouse'. We will use this key to deliver commands to these machines alone like so.

<pre>
salt '*' saltutil.sync_all
salt '*' saltutil.refresh_pillar
salt -C 'I@cluster_type:icehouse' state.highstate
</pre>


This instructs all the minions those who have 'openstack_version=icehouse' defined in their pillar data to download all the state defined for them and execute the same. If all goes well you can login to your newly installed openstack setup 'http://controller.icehouse/horizon'.


Cluster Definition
==================

To make things clear lets have a look at a part of the pillar configuration. Our 'pillar_root' defines a 'top.sls' file with following contents.

<pre>
icehouse: 
  "*.icehouse": 
    - cluster_resources
    - db_resources
    - access_resources
    - network_resources
    - openstack_cluster
    - deploy_files
    - {{ grains['os'] }}
    - {{ grains['os'] }}_repo
    - misc_openstack_options
</pre>

This in turn instructs all minions with ids matching the regular expression '*.icehouse' to use 'cluster_resources', 'db_references', 'access_resources', 'openstack_cluster', 'deploy_files' etc as their pillar source. Each of these files has a set of configurations for the cluster to be deployed.

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
  - "compute1.icehouse"
  - "compute2.icehouse"
controller: 
  - "controller.icehouse"
network: 
  - "network.icehouse"
storage:
  - "storage1.icehouse"
  - "storage2.icehouse"
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
  - "compute1.icehouse"
  - "compute2.icehouse"
controller: 
  - "controller.icehouse"
network: 
  - "network.icehouse"
storage:
  - "storage1.icehouse"
  - "storage2.icehouse"
queue_server:
  - "queueserver.icehouse"
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
salt -C 'I@cluster_type:icehouse' state.highstate
</pre>


Adding new compute node
=======================

Adding a new machine to a cluster is as easy as editing a json file. All you have to do is edit 'pillar_root/cluster_resources.sls' as below.

<pre>
compute: 
  - "compute1.icehouse"
  - "compute2.icehouse"
  - "compute3.icehouse"
</pre>

Then sync up the cluster as shown below.

<pre>
salt '*' saltutil.sync_all
salt '*' saltutil.refresh_pillar
salt -C 'I@cluster_type:icehouse' state.highstate
</pre>


Neutron Networking
==================
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
            network.icehouse: "eth3"
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
            network.icehouse: "eth3"
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
            network.icehouse: "eth3"
    vlan: 
      physnets: 
        Internal1: 
          bridge: "br-eth1"
          vlan_range: "100:200"
          hosts:
            network.icehouse: "eth2"
            compute1.icehouse: "eth2"
            compute2.icehouse: "eth2"
        Internal2:
          bridge: "br-eth2"
          vlan_range: "200:300"
          hosts:
            network.icehouse: "eth4"
            compute3.icehouse: "eth2"
</pre>

Single Interface Scenario
=========================
Most users trying openstack for first time would need OpenStack up and running on machine with single interface. Please set "single_nic" pillar in 'network_resources' to the 'primary interface id' in your machine. 

This will connect all bridges to a bridge named 'br-proxy'. Later you have to manually add your primary nic to this bridge and configure the bridge with the ip address of your primary nic. 

We have not automated the last part because you may loose connectivity to your minion at this phase and it is best you do it manually. Further setting up the briges in your 'interfaces configuration' file varies per distro. 

User would have to bear with us, untill we find formula for the same. 

Cinder Volume
=============
The 'cinder.volume' formula will find any free disk space available on the minion and create lvm partition and also a volume group 'cinder-volume'. This will be used by OpenStack's volume service. It is therefore adviced to deploy this particular formula on machines with available free space. We are using a custom state module for this purpose. Efforts are guaranteed to push the additional state to official salt state modules.

Packages, Services, Config files and Repositories
=================================================
The 'pillar_root' sub directory contains a <distro>.sls file that contains package names, service names, and config file paths for each of OpenStack's component. This file is supposed to be replicated for all the distros that you plan to use on your minions. 

The <distro>_repo.sls that has repository details specific to each distro that house the OpenStack packages. The parameters defined in the file should be the ones that are accepted by saltstack's pkgrepo module.


Contributing
============
As with all opensource projects, we need support too. However since this repo is used for deploying OpenStack clusters, it may end up making lots of changes after forking. These changes may include sensitive information in pillar. The changes may also be some trivial changes that are not necessary to be merged back here. So please follow the steps below.

After forking please create a new branch, which you will use to deploy openstack and make changes specific to yourself. If you feel any changes are good to be maintained and carried forwad, make them in the 'original' branches and merge them to your other branches. Always pull request from the 'original' branches.

As you may see the pillar data as of now only have 'Ubuntu.sls' and 'Debian.sls'. We need to update this repo with all those other distros available for OpenStack.

