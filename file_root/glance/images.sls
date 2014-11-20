{% from "cluster/resources.jinja" import get_candidate with context %}

{% for image_name in pillar.get('images', ()) %}
image-{{ image_name }}:
  glance:
    - image_present
    - name: {{ image_name }}
    - connection_user: {{ pillar['images'][image_name].get('user', 'admin') }}
    - connection_tenant: {{ pillar['images'][image_name].get('user', 'admin') }}
    - connection_password: {{ salt['pillar.get']('keystone:tenants:%s:users:%s:password' % (pillar['images'][image_name].get('user', 'admin'), pillar['images'][image_name].get('user', 'admin')), 'ADMIN') }}
    - connection_auth_url: {{ salt['pillar.get']('keystone:services:keystone:endpoint:internalurl', 'http://{0}:5000/v2.0').format(get_candidate(salt['pillar.get']('keystone:services:keystone:endpoint:endpoint_host_sls', default='keystone'))) }}
{% for image_attr in pillar['images'][image_name] %}
    - {{ image_attr }}: {{ pillar['images'][image_name][image_attr] }}
{% endfor %}
{% endfor %}
