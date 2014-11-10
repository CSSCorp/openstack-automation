{% from "cluster/resources.jinja" import get_candidate with context %}

{% for service_name in pillar['keystone']['services'] %}
{{ service_name }}_service:
  keystone:
    - service_present
    - name: {{ service_name }}
    - service_type: {{ pillar['keystone']['services'][service_name]['service_type'] }}
    - description: {{ pillar['keystone']['services'][service_name]['description'] }}
    - connection_token: {{ salt['pillar.get']('keystone:admin_token', default='ADMIN') }}
    - connection_endpoint: {{ salt['pillar.get']('keystone:services:keystone:endpoint:adminurl', default='http://{0}:35357/v2.0').format(get_candidate(salt['pillar.get']('keystone:services:keystone:endpoint:endpoint_host_sls', default='keystone'))) }}
{{ service_name }}_endpoint:
  keystone:
    - endpoint_present
    - name: {{ service_name }}
    - publicurl: {{ pillar['keystone']['services'][service_name]['endpoint']['publicurl'].format(get_candidate(pillar['keystone']['services'][service_name]['endpoint']['endpoint_host_sls'])) }}
    - adminurl: {{ pillar['keystone']['services'][service_name]['endpoint']['adminurl'].format(get_candidate(pillar['keystone']['services'][service_name]['endpoint']['endpoint_host_sls'])) }}
    - internalurl: {{ pillar['keystone']['services'][service_name]['endpoint']['internalurl'].format(get_candidate(pillar['keystone']['services'][service_name]['endpoint']['endpoint_host_sls'])) }}
    - connection_token: {{ salt['pillar.get']('keystone:admin_token', default='ADMIN') }}
    - connection_endpoint: {{ salt['pillar.get']('keystone:services:keystone:endpoint:adminurl', default='http://{0}:35357/v2.0').format(get_candidate(salt['pillar.get']('keystone:services:keystone:endpoint:endpoint_host_sls', default='keystone'))) }}
    - require:
      - keystone: {{ service_name }}_service
{% endfor %}
