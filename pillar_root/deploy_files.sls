# miscelanous files to be deployed on all hosts
files:
  gpl_host_pinning:
    name: /etc/apt/preferences.d/gplhost
    contents: |
      "Package: *\n
      Pin: origin archive.gplhost.com\n
      Pin-Priority: 999"
