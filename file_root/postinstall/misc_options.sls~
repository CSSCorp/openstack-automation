{% for conf_file in salt['pillar.get']('misc_options', default=()) %}
misc-{{ conf_file }}:
  file:
    - managed
    - name: "{{ salt['pillar.get']('conf_files:%s' % pillar['misc_options'][conf_file], default=pillar['misc_options'][conf_file]) }}"
    - user: "{{ salt['pillar.get']('conf_files:%s:user' % pillar['misc_options'][conf_file], default='root') }}"
    - group: "{{ salt['pillar.get']('conf_files:%s:group' % pillar['misc_options'][conf_file], default='root') }}"
    - mode: "{{ salt['pillar.get']('conf_files:%s:mode' % pillar['misc_options'][conf_file], default='644') }}"
{% if salt['pillar.get']('misc_options:%s:sections' % conf_file, default=None) %}
  ini:
    - options_present
    - name: "{{ salt['pillar.get']('conf_files:%s' % pillar['misc_options'][conf_file], default=pillar['misc_options'][conf_file]) }}"
    - sections:
{% for section_name in salt['pillar.get']('misc_options:%s:sections' % conf_file) %}
      {{ section_name }}:
        {% for option_name in pillar['misc_options'][conf_file]['sections'][section_name] %}
          {{ option_name }}: {{ pillar['misc_options'][conf_file]['sections'][section_name][option_name] }}
        {% endfor %}
{% endfor %}
{% endif %}
{% if salt['pillar.get']('misc_options:%s:service' % conf_file, default=None) %}
  service:
    - running
    - name: "{{ salt['pillar.get']('conf_files:%s:service' % pillar['misc_options'][conf_file]) }}"
    - watch:
      - file: "{{ salt['pillar.get']('conf_files:%s' % pillar['misc_options'][conf_file], default=pillar['misc_options'][conf_file]) }}"
      - ini: "{{ salt['pillar.get']('conf_files:%s' % pillar['misc_options'][conf_file], default=pillar['misc_options'][conf_file]) }}"
{% endif %}
{% endfor %}
