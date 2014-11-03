# miscelanous files to be deployed on all hosts
files:
  gpl_host_pinning:
    name: /etc/apt/preferences.d/gplhost
    contents: |
      "Package: *
      Pin: origin archive.gplhost.com
      Pin-Priority: 999"
