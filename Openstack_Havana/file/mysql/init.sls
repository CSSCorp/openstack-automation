#!jinja|json
{
  "mysql-conf-file": {
    "file": [
      "managed",
      {
        "group": "root",
        "mode": "644",
        "name": "/etc/mysql/my.cnf",
        "require": [
          {
            "pkg": "mysql-server"
          }
        ],
        "user": "root"
      }
    ],
    "ini": [
      "options_present",
      {
        "name": "/etc/mysql/my.cnf"
      },
      {
        "require": [
          {
            "file": "mysql-conf-file"
          }
        ]
      },
      {
        "sections": {
          "mysqld": {
            "bind-address": "0.0.0.0",
            "character-set-server": "utf8",
            "collation-server": "utf8_general_ci",
            "init-connect": "'SET NAMES utf8'"
          }
        }
      }
    ]
  },
  "mysql-server": {
    "pkg": [
      "installed"
    ],
    "service": [
      "running",
      {
        "name": "mysql"
      },
      {
        "watch": [
          {
            "pkg": "mysql-server"
          },
          {
            "ini": "mysql-conf-file"
          }
        ]
      }
    ]
  }
}
