# -*- coding: utf-8 -*-
"""
Created on Thu Nov  6 19:11:56 2014

@author: akilesh
"""
import re
import subprocess

def linux_interfaces():
    '''
    Obtain interface information for *NIX/BSD variants
    '''
    ifaces = dict()
    ip_path = 'ip'
    if ip_path:
        cmd1 = subprocess.Popen(
            '{0} link show'.format(ip_path),
            shell=True,
            close_fds=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT).communicate()[0]
        ifaces = _interfaces_ip(cmd1)
    return ifaces

def _interfaces_ip(out):
    '''
    Uses ip to return a dictionary of interfaces with various information about
    each (up/down state, ip address, netmask, and hwaddr)
    '''
    ret = dict()

    groups = re.compile('\r?\n').split(out)
    for group in groups:
        iface = None
        data = dict()

        for line in group.splitlines():
            match = re.match(r'^(\d*):\s+([\w.\-]+)(?:@)?([\w.\-]+)?:\s+<(.+)>', line)
            if match:
                ifindex, iface, parent, attrs = match.groups()
                if 'UP' in attrs.split(','):
                    data['up'] = True
                else:
                    data['up'] = False
                if parent:
                    data['parent'] = parent
                if ifindex:
                    data['index'] = ifindex
                continue
        if iface:
            ret[iface] = data
            del iface, data
    return ret