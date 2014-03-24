# -*- coding: utf-8 -*-
'''
Module for handling Cluster management in salt
'''


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
        for sls in __pillar__.get('install', {}).get(role, []):
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
    for host in list_hosts():
        if name in list_sls(machine=host):
            return host


def get_vlan_ranges():
    network_vlan_ranges = ""
    for physical_network in __pillar__['neutron'][__grains__['id']]:
        start_vlan = __pillar__['neutron'][__grains__['id']][physical_network].get('start_vlan', None)
        end_vlan = __pillar__['neutron'][__grains__['id']][physical_network].get('end_vlan', None)
        if start_vlan and end_vlan:
            network_vlan_ranges += "%s:%s:%s," % \
                (physical_network,
                 start_vlan,
                 end_vlan)
        else:
            network_vlan_ranges += "%s," % physical_network
    return network_vlan_ranges.rstrip(',')


def get_bridge_mappings():
    bridge_mappings = ""
    for physical_network in __pillar__['neutron'][__grains__['id']]:
        bridge_mappings += "%s:%s," % \
            (physical_network,
             __pillar__['neutron'][__grains__['id']][physical_network]['bridge'])
    return bridge_mappings.rstrip(',')


def create_init_bridges():
        __salt__['cmd.run']('ovs-vsctl --no-wait add-br ' + __pillar__['neutron']['intergration_bridge'])
        for physical_network in __pillar__['neutron'][__grains__['id']]:
            __salt__['cmd.run']('ovs-vsctl --no-wait add-br ' +
                                __pillar__['neutron'][__grains__['id']][physical_network]['bridge'])
            __salt__['cmd.run']('ovs-vsctl --no-wait add-port  %s %s' %
                                (__pillar__['neutron'][__grains__['id']][physical_network]['bridge'],
                                 __pillar__['neutron'][__grains__['id']][physical_network]['interface']))
            __salt__['cmd.run']('ip link set %s up' % __pillar__['neutron'][__grains__['id']][physical_network]['interface'])
            __salt__['cmd.run']('ip link set %s promisc on' % __pillar__['neutron'][__grains__['id']][physical_network]['interface'])