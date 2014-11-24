About the project
=================
The [project](https://github.com/Akilesh1597/salt-openstack/ "Openstack-Automation") gives you a working OpenStack cluster in a mater of minutes. We do this using [saltstack](http://docs.saltstack.com/ "Saltstack"). There is almost no coding involved and it can be easily maintained. Above all it is as easy as talking to your servers and asking them to configure themselves. 

Saltstack provides us an infrastructure management framework that makes our job easier. Saltstack supports most of tasks that you would want to perform while installing OpenStack and more. 

A few reasons why this is cool

1. Don't just install OpenStack but also keep your installation formulae versioned, so you can always go back to the last working set.
2. Salt formulae are not meant to just install. They can also serve to document the steps and the settings involved.
3. OpenStack has a release cycle of 6 months and every six months you just have to tinker with a few text files to stay in the game.
4. OpenStack has an ever increasing list of sub projects and we have an ever increasing number of formulae.

And we are opensource.

What is New
===========
1. Support for glance images to be created using glance state and module
2. Support for cinder added. Check 'Cinder Volume' section of README.
3. Support for all linux distros added. Check 'Packages, Services, Config files and Repositories section' of README.
4. Partial support for 'single server single nic' installations. Check section 'Single Interface Scenario' for details.
5. Pillar data has been segregated in multiple files according to its purpose. Check 'Customizations' section for details.
6. Branches icehouse and juno will alone exist and continue forward
7. Repo modified to be used as git fileserver backend. User may use 'git_pillar' pointed to 'pillar_root' sub directory or download the files to use in 'roots' backend.
8. Pull request to the project has some regulations, documented towards the end of the README.
9. 'yaml' will be default format for sls files. This is done as maintaining sls files across format is causing mismatches and errors. Further 'json' does not go well with 'jinja' templating(formulas end up less readable).
10. 'cluster_ops' salt module has been removed. Its functionality has been achieved using 'jinja macros', in an attempt to remove any dependencies that are not available in saltstack's list of modules.

Yet to Arrive
=============
1. Neutron state and execution module, pilllar and formulas for creation of initial networks.
2. Pillar and formulas for creation of instances.

Getting started
===============
When you are ready to install OpenStack modify the [salt-master configuration](http://docs.saltstack.com/en/latest/ref/configuration/master.html "salt-master configuration") file at "/etc/salt/master" to hold the below contents.

<pre>
fileserver_backend:
  - roots
  - git
gitfs_remotes:
  - https://github.com/Akilesh1597/salt-openstack.git:
    root: file_root
ext_pillar:
  - git: icehouse https://github.com/Akilesh1597/salt-openstack.git root=pillar_root
jinja_trim_blocks: True
jinja_lstrip_blocks: True
</pre>

This will create a new [environment](http://docs.saltstack.com/ref/file_server/index.html#environments "Salt Environments") called "icehouse" in your state tree. The 'file_roots' directory of the github repo will have [state definitions](http://docs.saltstack.com/topics/tutorials/starting_states.html "Salt States") in a bunch of '.sls' files and the few special directories, while the 'pillar_root' directory has your cluster definition files. 

At this stage I assume that you have a machine with minion id 'openstack.icehouse' and ip address '192.168.1.1' [added to the salt master](http://docs.saltstack.com/topics/tutorials/walkthrough.html#setting-up-a-salt-minion "minion setup").

Lets begin...

<pre>
salt-run fileserver.update
salt '*' saltutil.sync_all
salt -C 'I@cluster_type:icehouse' state.highstate
</pre>

This instructs the minion having 'cluster_type=icehouse' defined in its pillar data to download all the formulae defined for it and execute the same. If all goes well you can login to your newly installed OpenStack setup at 'http://192.168.1.1/horizon'. 

But that is not all. We can have a fully customized install with multiple hosts performing different roles, customized accounts and databases. All this can be done simply by manipulating the [pillar data](http://docs.saltstack.com/topics/pillar/ "Salt Pillar").

Check [salt walkthrough](http://docs.saltstack.com/en/latest/topics/tutorials/walkthrough.html "walkthrough") to understand how salt works.

Multi node setup
================
Edit 'cluster_resources.sls' file inside 'pillar_root' sub directory. It looks like below.
<pre>
roles: 
  - "compute"
  - "controller"
  - "network"
  - "storage"
compute: 
  - "openstack.icehouse"
controller: 
  - "openstack.icehouse"
network: 
  - "openstack.icehouse"
storage:
  - "openstack.icehouse"
</pre>
It just means that in our cluster all roles are played by a single host 'openstack.icehouse'. Now let just distribute the responsibilities.
<pre>
roles: 
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
  - "storage.icehouse"
</pre>
We just added five hosts to perform different roles. "compute1.icehouse" and "compute2.icehouse" perform the role "compute" for example. Make sure the tell their ip addresses in the file 'openstack_cluster.sls'.
<pre>
hosts: 
  controller.icehouse: 192.168.1.1
  network.icehouse: 192.168.1.2
  storage.icehouse: 192.168.1.3
  compute1.icehouse: 192.168.1.4
  compute2.icehouse: 192.168.1.5
</pre>
Lets sync up.
<pre>
salt-run fileserver.update
salt '*' saltutil.sync_all
salt -C 'I@cluster_type:icehouse' state.highstate
</pre>
Ah and if you use git as your backend, you have to fork us before doing any changes. 

Add new roles
=============
Lets say we want the 'queue server' as a separate role. This is how we do it.
1. Add a new role "queue_server" under "roles"
2. Define what minions will perform the role of "queue_server"
3. Finally define which formula deploys a "queue_server" under "sls" under "queue_server" section.
<pre>
roles: 
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
  - "storage.icehouse"
queue_server:
  - "queueserver.icehouse"
sls: 
  queue_server:
    - "queue.rabbit"
  controller: 
    - "generics.host"
    - "mysql"
    - "mysql.client"
    - "mysql.OpenStack_dbschema"
    - "keystone"
    - "keystone.OpenStack_tenants"
    - "keystone.OpenStack_users"
    - "keystone.OpenStack_services"
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
You may want the same machine to perform many roles or you may add a new machine. Make sure to update the machine's ip address as mentioned earlier.

Customizations
==============
The pillar data has been structured as below, in order have a single sls file to modify, for each kind of customization. 
<pre>
---------------------------------------------------------------------------------
|Pillar File		| Purpose						|
|:----------------------|:------------------------------------------------------|
|OpenStack_cluster	| Generic cluster Data					| 
|access_resources	| Keystone tenants, users, roles, services and endpoints|
|cluster_resources	| Hosts, Roles and their correspoinding formulas	|
|network_resources	| OpenStack Neutron data, explained below		|
|db_resources		| Databases, Users, Passwords and Grants		|
|deploy_files		| Arbitrary files to be deployed on all minions		|
|misc_OpenStack_options	| Arbitrary OpenStack options and affected services	|
|[DISTRO].sls		| Distro specific package data				|
|[DISTRO]_repo.sls	| Distro specific repository data			|
---------------------------------------------------------------------------------
</pre>
Should you need more 'tenants' or change credentials of an OpenStack user you should look into 'access_resources.sls' under 'pillar_root'. You may tweak your OpenStack in any way you want.

Neutron Networking
==================
'network_resources' under 'pillar_root' defines the OpenStack ["Data" and "External" networks](http://fosskb.wordpress.com/2014/06/10/managing-OpenStack-internaldataexternal-network-in-one-interface/ "Openstack networking"). The default configuration will install a "gre" mode "Data" network and a "flat" mode "External" network, and looks as below.

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

For vlan mode tenant networks, you need to add 'vlan' under 'tenant_network_types' and for each compute host and network host specify the list of [physical networks](http://fosskb.wordpress.com/2014/06/19/l2-connectivity-in-OpenStack-using-openvswitch-mechanism-driver/ "Openstack physical networks") and their corresponding bridge, interface and allowed vlan range.

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
Most users trying OpenStack for first time would need OpenStack up and running on machine with single interface. Please set "single_nic" pillar in 'network_resources' to the 'primary interface id' in your machine. 

This will connect all bridges to a bridge named 'br-proxy'. Later you have to manually add your primary nic to this bridge and configure the bridge with the ip address of your primary nic. 

We have not automated the last part because you may loose connectivity to your minion at this phase and it is best you do it manually. Further setting up the briges in your 'interfaces configuration' file varies per distro. 

User would have to bear with us, untill we find formula for the same. 

Cinder Volume
=============
The 'cinder.volume' formula will find any free disk space available on the minion and create lvm partition and also a volume group 'cinder-volume'. This will be used by OpenStack's volume service. It is therefore adviced to deploy this particular formula on machines with available free space. We are using a custom state module for this purpose. Efforts are guaranteed to push the additional state to official salt state modules.

Packages, Services, Config files and Repositories
=================================================
The 'pillar_root' sub directory contains a [DISTRO].sls file that contains package names, service names, and config file paths for each of OpenStack's component. This file is supposed to be replicated for all the distros that you plan to use on your minions. 

The [DISTRO]_repo.sls that has repository details specific to each distro that house the OpenStack packages. The parameters defined in the file should be the ones that are accepted by saltstack's pkgrepo module.


Contributing
============
As with all opensource projects, we need support too. However since this repo is used for deploying OpenStack clusters, it may end up making lots of changes after forking. These changes may include sensitive information in pillar. The changes may also be some trivial changes that are not necessary to be merged back here. So please follow the steps below.

After forking please create a new branch, which you will use to deploy OpenStack and make changes specific to yourself. If you feel any changes are good to be maintained and carried forwad, make them in the 'original' branches and merge them to your other branches. Always pull request from the 'original' branches.

As you may see the pillar data as of now only have 'Ubuntu.sls' and 'Debian.sls'. We need to update this repo with all those other distros available for OpenStack.

