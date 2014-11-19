{% for image_name in pillar.get('images', ()) %}
image-{{ image_name }}:
  glance:
    - image_present
    - name: {{ image_name }}
    - connection_user: {{ pillar['images'][image_name].get('user', 'admin') }}
    - connection_tenant: {{ pillar['images'][image_name].get('user', 'admin') }}
    - connection_password: {{ salt['pillar.get']('keystone:tenants:%s:users:%s' % (pillar['images'][image_name].get('user', 'admin'), pillar['images'][image_name].get('user', 'admin')), 'ADMIN') }}
    - connection_auth_url: {{ salt['pillar.get']('keystone:services:keystone:endpoint:internalurl', 'http://127.0.0.1:5000/v2.0') }}
{% for image_attr in pillar['images'][image_name] %}
    - {{ image_attr }}: {{ pillar['images'][image_name][image_attr] }}
{% endfor %}
{% endfor %}
