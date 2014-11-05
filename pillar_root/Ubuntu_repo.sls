pkgrepo:
  pre_repo_additions:
    - "software-properties-common"
    - "ubuntu-cloud-keyring"
  repos:
    Juno-Cloud:
      name: "deb http://ubuntu-cloud.archive.canonical.com/ubuntu trusty-updates/icehouse main"
      file: "/etc/apt/sources.list.d/cloudarchive-icehouse.list"
