{% for package in salt['pillar.get']('pkgrepo:pre_repo_additions', default=()) %}
{{ package }}-install:
  pkg:
    - installed
    - name: {{ package }}
{% endfor %}


{% for repo in salt['pillar.get']('pkgrepo:repos', default=()) %}
{{ repo }}-repo:
  pkgrepo:
    - managed
{% for repo_option in pillar['pkgrepo']['repos'][repo] %}
    - {{ repo_option }}: {{ pillar['pkgrepo']['repos'][repo][repo_option] }}
{% endfor %}
{% if salt['pillar.get']('pkgrepo:pre_repo_additions', default=()) %}
    - require:
{% for package in salt['pillar.get']('pkgrepo:pre_repo_additions', default=()) %}
      - pkg: {{ package }}
{% endfor %}
{% endif %}
{% endfor %}


{% for package in salt['pillar.get']('pkgrepo:post_repo_additions', default=()) %}
{{ package }}-install:
  pkg:
    - latest
    - name: {{ package }}
{% if salt['pillar.get']('pkgrepo:repos', default=()) %}
    - require:
{% for repo in salt['pillar.get']('pkgrepo:repos', default=()) %}
      - pkgrepo: {{ repo }}-repo
{% endfor %}
{% endif %}
{% endfor %}
