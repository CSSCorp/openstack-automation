
replace require conditions


keystone.user: "admin"
keystone.password: "admin_pass"
keystone.tenant: "admin"
keystone.auth_url: "http://brown:5000/v2.0/"

Check if these are necessary for keystone state and module and add them if necessary



add documentation
if a packages is not valid for a distro then replace that package name with something already bing installed in distro.sls file

example nova-ajax-console-proxy is replaced with novnc in Debian.sls. tHis does not affect installation, except that the state will be run twice


add documentation
To deploy miscelanous files

add documentation

repo.sls , repo addition , pre repo addition  and post repo addition


create support for adding miscelanous config file changes

it should restart corresponding service, 

but it should not disturb the ini.options_present state in the components regular sls file

ssl version of dashboard

open rabbitmq port


