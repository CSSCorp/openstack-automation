#!jinja|json
{
	{% if 'pkg_proxy_url' in pillar %}
	{% if grains['os'] == 'Ubuntu' %}
    "apt-cache-proxy": {
        "file": [
            "managed",
            {
                "name": "/etc/apt/apt.conf.d/01proxy",
                "contents": "Acquire::http::Proxy \"{{ pillar['pkg_proxy_url'] }}\";"
            }
        ]
    }
    {% endif %}
    {% endif %}
}
