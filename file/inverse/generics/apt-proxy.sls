#!jinja|json
{
    {% if grains['os'] == 'Ubuntu' %}
    "apt-cache-proxy": {
        "file": [
            "absent",
            {
                "name": "/etc/apt/apt.conf.d/01proxy"
            }
        ]
    }
    {% endif %}
}
