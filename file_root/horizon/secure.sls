apache_rewrite_enable:
  apache_module:
    - enable
    - name: rewrite
apache_ssl_enable:
  apache_module:
    - enable
    - name: ssl
apache-service-module-enable:
  service:
    - running
    - name: "{{ salt['pillar.get']('services:apache', default='apache2') }}"
    - watch:
      - apache_module: apache_rewrite_enable
      - apache_module: apache_ssl_enable
