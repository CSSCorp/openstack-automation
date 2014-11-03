pkgrepo:
  pre_repo_additions:
    - "software-properties-common"
    - "ubuntu-cloud-keyring"
  repos:
    Juno-Cloud:
      name: "deb http://ubuntu-cloud.archive.canonical.com/ubuntu trusty-updates/juno main"
      file: "/etc/apt/sources.list.d/cloudarchive-juno.list"
  post_repo_addition:
    - "python-argparse"
    - "iproute"
    - "python-crypto"
    - "python-psutil"
    - "libusb-1.0-0"
    - "libyaml-0-2"
