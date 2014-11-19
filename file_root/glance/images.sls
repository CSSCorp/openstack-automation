{% for image_name in pillar.get('images', ()) %}
image-{{ image_name }}:
  glance:
    - name: {{ image_name }}
{% for image_attr in pillar['images'][image_name] %}
    - {{ image_attr }}: {{ pillar['images'][image_name][image_attr] }}
{% endfor %}
{% endfor %}
