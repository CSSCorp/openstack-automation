#!jinja|json
{
    "rabbitmq-server": {
        "pkg": [
            "installed",
            {
                "require": [
                    {
                        "pkg": "ntp"
                    }
                ]
            }
        ]
    }
}
