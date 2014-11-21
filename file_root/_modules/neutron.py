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

import sys
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


def auth_decorator(func_name):
    def decorator_method(_,
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
        neutron_interface = Neutron(client.Client(
            endpoing_url=endpoint, token=token))
        method_name = getattr(neutron_interface, func_name, None)
        method_name(**kwargs)
    return decorator_method


class Neutron(object):
    def __init__(self, client=None):
        super(Neutron, self).__init__()
        self._client = client

    @auth_decorator
    def list_floatingips(self, **kwargs):
        return self.client.list_floatingips(**kwargs)['floatingips']

    def list_security_groups(self, **kwargs):
        return self.client.list_security_groups(**kwargs)['security_groups']

    def list_subnets(self, **kwargs):
        return self.client.list_subnets(self, **kwargs)['subnets']

    def list_networks(self, **kwargs):
        return self.client.list_networks(self, **kwargs)['networks']

    def list_ports(self, **kwargs):
        return self.client.list_ports(self, **kwargs)['ports']

    def list_routers(self, **kwargs):
        return self.client.list_routers(self, **kwargs)['routers']

    def update_security_group(self, **kwargs):
        self.client.update_security_group({'security_group': kwargs})

    def update_floating_ip(self, fip, port_id):
        self.client.update_floatingip(fip, {"floatingip":
                                            {"port_id": port_id}})

    def update_subnet(self, subnet_id, subnet):
        self.client.update_subnet(subnet_id, {'subnet': subnet})

    def update_router(self, router_id, external_network_id):
        self.client.update_router(router_id,
                                  {'router':
                                      {'external_gateway_info':
                                          {'network_id':
                                              external_network_id}}})

    def create_router(self, **kwargs):
        response = self.client.create_router({'router': kwargs})
        if 'router' in response and 'id' in response['router']:
            return response['router']['id']

    def router_add_interface(self, router_id, subnet_id):
        self.client.add_interface_router(router_id, {'subnet_id': subnet_id})

    def router_rem_interface(self, router_id, subnet_id):
        self.client.remove_interface_router(router_id,
                                            {'subnet_id': subnet_id})

    def create_security_group(self, **kwargs):
        response = self.client.create_security_group({'security_group':
                                                     kwargs})
        if 'security_group' in response and 'id' in response['security_group']:
            return response['security_group']['id']

    def create_security_group_rule(self, rule):
        self.client.create_security_group_rule({'security_group_rule':
                                                rule})

    def create_floatingip(self, floatingip):
        response = self.client.create_floatingip({'floatingip': floatingip})
        if 'floatingip' in response and 'id' in response['floatingip']:
            return response['floatingip']['id']

    def create_subnet(self, **kwargs):
        response = self.client.create_subnet({'subnet': kwargs})
        if 'subnet' in response and 'id' in response['subnet']:
            return response['subnet']['id']

    def create_network(self, **kwargs):
        response = self.client.create_network({'network': kwargs})
        if 'network' in response and 'id' in response['network']:
            return response['network']['id']

    def create_port(self, **kwargs):
        response = self.client.create_port({'port': kwargs})
        if 'port' in response and 'id' in response['port']:
            return response['port']['id']

    def update_port(self, port_id, port):
        self.client.update_port(port_id, {'port': port})

    def delete_floating_ip(self, floating_ip_id):
        self.client.delete_floatingip(floating_ip_id)

    def delete_security_group(self, sg_id):
        self.client.delete_security_group(sg_id)

    def delete_security_group_rule(self, rule):
        sg_rules = self.client.list_security_group_rules(
            security_group_id=rule['security_group_id'])
        for sg_rule in sg_rules['security_group_rules']:
            sgr_id = sg_rule.pop('id')
            if sg_rule == rule:
                self.client.delete_security_group_rule(sgr_id)

    def delete_subnet(self, subnet_id):
        self.client.delete_subnet(subnet_id)

    def delete_network(self, network_id):
        self.client.delete_network(network_id)

    def delete_router(self, router_id):
        self.client.delete_router(router_id)

    @staticmethod
    def __virtual__():
        '''
        Only load this module if glance
        is installed on this minion.
        '''
        if HAS_NEUTRON:
            return 'neutron'
        return False


sys.modules[__name__] = Neutron()