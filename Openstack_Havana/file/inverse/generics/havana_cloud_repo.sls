#!jinja|json
{
	{% for repo in pillar['cloud_repos'] %}
		"{{ repo['reponame'] }}": {
			"file": [
				"absent",
				{
					"file": "{{ repo['file'] }}"
				},
				{
					"require": [
						{
							"pkg": "cloud-repo-keyring"
						}
					]
				}
			]
		},
    {% endfor %}
    {% if grains['os'] == 'Ubuntu' %}
		"cloud-repo-keyring": {
			"pkg": [
				"purged",
				{
					"name": "ubuntu-cloud-keyring"
				}
			]
		},
    {% endif %}
    "cloud-keyring-refresh-repo": {
		"module": [
			"run",
			{
				"name": "saltutil.sync_all"
			}
		]
    }
}
