rabbitmq-server-install:
  pkg:
    - installed
    - name: {{ salt['pillar.get']('packages:rabbitmq', default='rabbitmq-server') }}
rabbit-port-open:
  file:
    - replace
    - name: {{ salt['pillar.get']('conf_files:rabbitmq', default='/etc/rabbitmq/rabbitmq-env.conf') }}
    - pattern: 127.0.0.1
    - repl: 0.0.0.0
    - require:
      - pkg: rabbitmq-server-install
rabbitmq-service-running:
  service:
    - running
    - name: {{ salt['pillar.get']('services:rabbitmq', default='rabbitmq') }}
    - watch:
      - pkg: rabbit-server-install
      - file: rabbit-port-open
