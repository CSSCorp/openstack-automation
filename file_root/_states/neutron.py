# -*- coding: utf-8 -*-
'''
Management of Neutron resources
===============================

:depends:   - neutronclient Python module
:configuration: See :py:mod:`salt.modules.neutron` for setup instructions.

.. code-block:: yaml

    neutron network present:
      neutron.network_present:
        - name: Netone
        - provider_physical_network: PHysnet1
        - provider_network_type: vlan
'''
