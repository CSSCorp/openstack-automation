{% for conf_file in salt['pillar.get']('misc_options', default=()) %}
misc-{{ conf_file }}:
  file:
    - managed
    - name: "{{ salt['pillar.get']('conf_files:%s' % conf_file, default=conf_file) }}"
    - user: "{{ salt['pillar.get']('conf_files:%s:user' % conf_file, default='root') }}"
    - group: "{{ salt['pillar.get']('conf_files:%s:group' % conf_file, default='root') }}"
    - mode: "{{ salt['pillar.get']('conf_files:%s:mode' % conf_file, default='644') }}"
{% if salt['pillar.get']('misc_options:%s:sections' % conf_file, default=None) %}
  ini:
    - options_present
    - name: "{{ salt['pillar.get']('conf_files:%s' % conf_file, default=conf_file) }}"
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
    - name: "{{ salt['pillar.get']('services:%s' % pillar['misc_options'][conf_file]['service'], default=pillar['misc_options'][conf_file]['service']) }}"
    - watch:
      - file: "{{ salt['pillar.get']('conf_files:%s' % conf_file, default=conf_file) }}"
      - ini: "{{ salt['pillar.get']('conf_files:%s' % conf_file, default=conf_file) }}"
{% endif %}
{% endfor %}
