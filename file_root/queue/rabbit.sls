rabbitmq-server-install:
  pkg:
    - installed
    - name: {{ salt['pillar.get']('packages:rabbitmq', default='rabbitmq-server') }}
rabbitmq-service-running:
  service:
    - running
    - name: {{ salt['pillar.get']('services:rabbitmq', default='rabbitmq') }}
