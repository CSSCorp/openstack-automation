#!jinja|json
{
	{% if grains['os'] == 'Ubuntu' %}
		"linux-headers-install": {
			"pkg": [
				"purged",
				{
					"name": "linux-headers-{{ grains['kernelrelease'] }}"
				}
			]
		}
	{% endif %}
}
