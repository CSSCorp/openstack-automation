# -*- coding: utf-8 -*-
'''
Module for handling Cluster management in salt
'''
import re

def __virtual__():
    '''
    No deps. Load the module
    '''
    return 'cluster_ops'


def list_sls(machine=None):
    '''
    Get list of sls to apply from pillar data
    '''
    host_sls = []
    for role in list_roles(machine):
        for sls in __pillar__.get('sls', {}).get(role, []):
            if sls not in host_sls:
                host_sls.append(sls)
    return host_sls


def list_roles(machine=None):
    '''
    Get list of roles played by host
    '''
    if not machine:
        machine = __grains__['id']
    return [cluster_entity for cluster_entity in
            __pillar__.get('cluster_entities', [])
            if machine in __pillar__.get(cluster_entity, [])]


def list_hosts():
    '''
    Get list of hosts available in cluster
    '''
    host_list = []
    for cluster_entity in __pillar__.get('cluster_entities', []):
        for host in __pillar__.get(cluster_entity, []):
            if host not in host_list:
                host_list.append(host)
    return host_list


def get_candidate(name=None):
    """
    Return the host runing the particular service
    """
    for host in list_hosts():
        for sls in list_sls(machine=host):
            if re.match(name, sls):
                return host


def get_install_flavor(name=None):
    """
    Return the particular flavor of a service
    queue.* would return rabbit if queue.rabbit is in list of sls
    """
    name = name.replace('*', '(.*)')
    for host in list_hosts():
        for sls in list_sls(machine=host):
            match = re.match(name, sls)
            if match:
                return match.group(1)


def create_init_bridges():
	try:
		__salt__['cmd.run']('ovs-vsctl --no-wait add-br ' + __pillar__['neutron']['intergration_bridge'])
	except:
		pass
	for physical_network in __pillar__['neutron'].get(__grains__['id'], {}):
		try:
			__salt__['cmd.run']('ovs-vsctl --no-wait add-br ' +
								__pillar__['neutron'][__grains__['id']][physical_network]['bridge'])
			__salt__['cmd.run']('ovs-vsctl --no-wait add-port  %s %s' %
								(__pillar__['neutron'][__grains__['id']][physical_network]['bridge'],
								 __pillar__['neutron'][__grains__['id']][physical_network]['interface']))
			__salt__['cmd.run']('ip link set %s up' % __pillar__['neutron'][__grains__['id']][physical_network]['interface'])
			__salt__['cmd.run']('ip link set %s promisc on' % __pillar__['neutron'][__grains__['id']][physical_network]['interface'])
		except:
			pass
