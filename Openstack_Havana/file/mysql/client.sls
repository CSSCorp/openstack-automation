#!jinja|json
{
    "mysql-client": {
        "pkg": [
            "installed"
        ]
    },
    "python-mysqldb": {
        "pkg": [
            "installed",
            {
                "require": [
                    {
                        "pkg": "mysql-client"
                    }
                ]
            }
        ]
    }
}
