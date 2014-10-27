{% for service_name in pillar['keystone']['services'] %}
{{ service_name }}_service:
  keystone:
    - service_present
    - name: {{ service_name }}
    - service_type: {{ pillar['keystone']['services'][service_name]['service_type'] }}
    - description: {{ pillar['keystone']['services'][service_name]['description'] }}
{{ service_name }}_endpoint:
  keystone:
    - endpoint_present
    - name: {{ service_name }}
    - publicurl: {{ pillar['keystone']['services'][service_name]['endpoint']['publicurl'] % salt['cluster_ops.get_candidate'](pillar['keystone']['services'][service_name]['endpoint']['endpoint_host_sls']) }}
    - adminurl: {{ pillar['keystone']['services'][service_name]['endpoint']['adminurl'] % salt['cluster_ops.get_candidate'](pillar['keystone']['services'][service_name]['endpoint']['endpoint_host_sls']) }}
    - internalurl: {{ pillar['keystone']['services'][service_name]['endpoint']['internalurl'] % salt['cluster_ops.get_candidate'](pillar['keystone']['services'][service_name]['endpoint']['endpoint_host_sls']) }}
    - require:
      - keystone: {{ service_name }}_service
{% endfor %}
