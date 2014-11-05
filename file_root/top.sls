{% from "cluster/resources.jinja" import formulas with context %}
juno:
  "*.juno":
    - generics.*
{% for formula in formulas %}
    - {{ formula }}
{% endfor %}
    - postinstall.misc_options
