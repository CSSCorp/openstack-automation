linux-headers-install:
  pkg:
    - installed
    - name: {{ salt['pillar.get']('packages:linux-headers') }}

