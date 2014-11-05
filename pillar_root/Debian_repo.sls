pkgrepo:
  pre_repo_additions:
    - "gplhost-archive-keyring"
  repos:
    Juno-Cloud:
      name: "deb http://archive.gplhost.com/debian icehouse main"
      file: "/etc/apt/sources.list.d/gplhost-icehouse.list"
      human_name: "GPLHost Juno packages"
    Juno-Cloud-backports:
      name: "deb http://archive.gplhost.com/debian icehouse-backports main"
      file: "/etc/apt/sources.list.d/gplhost-icehouse.list"
      human_name: "GPLHost Juno Backports packages"
  post_repo_additions:
    - "python-argparse"
    - "iproute"
    - "python-crypto"
    - "python-psutil"
    - "libusb-1.0-0"
    - "libyaml-0-2"
