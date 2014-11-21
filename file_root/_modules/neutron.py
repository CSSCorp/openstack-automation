# -*- coding: utf-8 -*-
'''
Module for handling openstack neutron calls.

:optdepends:    - neutronclient Python adapter
:configuration: This module is not usable until the following are specified
    either in a pillar or in the minion's config file::

        keystone.user: admin
        keystone.password: verybadpass
        keystone.tenant: admin
        keystone.tenant_id: f80919baedab48ec8931f200c65a50df
        keystone.insecure: False   #(optional)
        keystone.auth_url: 'http://127.0.0.1:5000/v2.0/'

    If configuration for multiple openstack accounts is required, they can be
    set up as different configuration profiles:
    For example::

        openstack1:
          keystone.user: admin
          keystone.password: verybadpass
          keystone.tenant: admin
          keystone.tenant_id: f80919baedab48ec8931f200c65a50df
          keystone.auth_url: 'http://127.0.0.1:5000/v2.0/'

        openstack2:
          keystone.user: admin
          keystone.password: verybadpass
          keystone.tenant: admin
          keystone.tenant_id: f80919baedab48ec8931f200c65a50df
          keystone.auth_url: 'http://127.0.0.2:5000/v2.0/'

    With this configuration in place, any of the keystone functions can make use
    of a configuration profile by declaring it explicitly.
    For example::

        salt '*' glance.image_list profile=openstack1
'''

import logging
LOG = logging.getLogger(__name__)
# Import third party libs
HAS_NEUTRON = False
try:
    from neutronclient.v2_0 import client
    HAS_NEUTRON = True
except ImportError:
    pass

__opts__ = {}
def __virtual__():
    '''
    Only load this module if glance
    is installed on this minion.
    '''
    if HAS_NEUTRON:
        return 'neutron'
    return False


def auth_decorator(func_name):
    def decorator_method(
            profile=None, connection_user=None, connection_password=None,
            connection_tenant=None, connection_endpoint=None,
            conection_token=None, connection_auth_url=None, **kwargs):
        kstone = __salt__['keystone.auth'](
            profile=profile, connection_user=connection_user, connection_password=connection_password,
            connection_tenant=connection_tenant, connection_endpoint=connection_endpoint,
            conection_token=conection_token, connection_auth_url=connection_auth_url)
        token = kstone.auth_token
        endpoint = kstone.service_catalog.url_for(
            service_type='network',
            endpoint_type='publicURL')
        neutron_interface = client.Client(
            endpoing_url=endpoint, token=token)
        LOG.error(neutron_interface.list_agents())
        return func_name(neutron_interface, **kwargs)
    return decorator_method


@auth_decorator
def list_floatingips(neutron_interface, **kwargs):
    return neutron_interface.list_floatingips(**kwargs)['floatingips']

def list_security_groups(neutron_interface, **kwargs):
    return neutron_interface.list_security_groups(**kwargs)['security_groups']

def list_subnets(neutron_interface, **kwargs):
    return neutron_interface.list_subnets(neutron_interface, **kwargs)['subnets']

def list_networks(neutron_interface, **kwargs):
    return neutron_interface.list_networks(neutron_interface, **kwargs)['networks']

def list_ports(neutron_interface, **kwargs):
    return neutron_interface.list_ports(neutron_interface, **kwargs)['ports']

def list_routers(neutron_interface, **kwargs):
    return neutron_interface.list_routers(neutron_interface, **kwargs)['routers']

def update_security_group(neutron_interface, **kwargs):
    neutron_interface.update_security_group({'security_group': kwargs})

def update_floating_ip(neutron_interface, fip, port_id):
    neutron_interface.update_floatingip(fip, {"floatingip":
                                        {"port_id": port_id}})

def update_subnet(neutron_interface, subnet_id, subnet):
    neutron_interface.update_subnet(subnet_id, {'subnet': subnet})

def update_router(neutron_interface, router_id, external_network_id):
    neutron_interface.update_router(router_id,
                              {'router':
                                  {'external_gateway_info':
                                      {'network_id':
                                          external_network_id}}})

def create_router(neutron_interface, **kwargs):
    response = neutron_interface.create_router({'router': kwargs})
    if 'router' in response and 'id' in response['router']:
        return response['router']['id']

def router_add_interface(neutron_interface, router_id, subnet_id):
    neutron_interface.add_interface_router(router_id, {'subnet_id': subnet_id})

def router_rem_interface(neutron_interface, router_id, subnet_id):
    neutron_interface.remove_interface_router(router_id,
                                        {'subnet_id': subnet_id})

def create_security_group(neutron_interface, **kwargs):
    response = neutron_interface.create_security_group({'security_group':
                                                 kwargs})
    if 'security_group' in response and 'id' in response['security_group']:
        return response['security_group']['id']

def create_security_group_rule(neutron_interface, rule):
    neutron_interface.create_security_group_rule({'security_group_rule':
                                            rule})

def create_floatingip(neutron_interface, floatingip):
    response = neutron_interface.create_floatingip({'floatingip': floatingip})
    if 'floatingip' in response and 'id' in response['floatingip']:
        return response['floatingip']['id']

def create_subnet(neutron_interface, **kwargs):
    response = neutron_interface.create_subnet({'subnet': kwargs})
    if 'subnet' in response and 'id' in response['subnet']:
        return response['subnet']['id']

def create_network(neutron_interface, **kwargs):
    response = neutron_interface.create_network({'network': kwargs})
    if 'network' in response and 'id' in response['network']:
        return response['network']['id']

def create_port(neutron_interface, **kwargs):
    response = neutron_interface.create_port({'port': kwargs})
    if 'port' in response and 'id' in response['port']:
        return response['port']['id']

def update_port(neutron_interface, port_id, port):
    neutron_interface.update_port(port_id, {'port': port})

def delete_floating_ip(neutron_interface, floating_ip_id):
    neutron_interface.delete_floatingip(floating_ip_id)

def delete_security_group(neutron_interface, sg_id):
    neutron_interface.delete_security_group(sg_id)

def delete_security_group_rule(neutron_interface, rule):
    sg_rules = neutron_interface.list_security_group_rules(
        security_group_id=rule['security_group_id'])
    for sg_rule in sg_rules['security_group_rules']:
        sgr_id = sg_rule.pop('id')
        if sg_rule == rule:
            neutron_interface.delete_security_group_rule(sgr_id)

def delete_subnet(neutron_interface, subnet_id):
    neutron_interface.delete_subnet(subnet_id)

def delete_network(neutron_interface, network_id):
    neutron_interface.delete_network(network_id)

def delete_router(neutron_interface, router_id):
    neutron_interface.delete_router(router_id)
