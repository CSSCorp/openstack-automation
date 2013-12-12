#!jinja|json
{
    "salt": {
        "host": [
            "present",
            {
                "ip": {{ pillar['salt-master'] }}
            }
        ]
    }
    {% for server in pillar['hosts'] %}
    ,"{{ server }}": {
        "host": [
            "absent",
            {
                "ip" : "{{ pillar['hosts'][server] }}"
            }
        ]
    }
    {% endfor %}
}
