#!jinja|json
{
    {% for server in pillar['hosts'] %}
    "{{ server }}": {
        "host": [
            "present",
            {
                "ip" : "{{ pillar['hosts'][server] }}"
            }
        ]
    },
    {% endfor %}
    "salt": {
        "host": [
            "present",
            {
                "ip": "{{ pillar['hosts']['salt'] }}"
            }
        ]
    }

}
