{% if 'pkg_proxy_url' in pillar %}
{% if grains['os'] in ('Ubuntu', 'Debian') %}
apt-cache-proxy:
  file:
    - managed
    - name: /etc/apt/apt.conf.d/01proxy
    - contents: "Acquire::http::Proxy \"{{ pillar['pkg_proxy_url'] }}\";"
{% endif %}
{% if grains['os'] in ('Redhat', 'Fedora', 'CentOS') %}
yum-cache-proxy:
  file:
    - manage
    - name: /etc/yum/yum.repos.d/01proxy
    - contents: "proxy = {{ pillar['pkg_proxy_url'] }}"
{% endif %}
{% endif %}
