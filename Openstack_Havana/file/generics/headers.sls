#!jinja|json
{
	{% if grains['os'] == 'Ubuntu' %}
		"linux-headers-install": {
			"pkg": [
				"installed",
				{
					"name": "linux-headers-{{ grains['kernelrelease'] }}"
				}
			]
		}
	{% endif %}
}
