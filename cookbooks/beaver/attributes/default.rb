default['beaver']['base_dir'] = "/opt/beaver"
default['beaver']['config_dir'] = "/etc/beaver"
default['beaver']['configd_dir'] = "#{node['beaver']['config_dir']}/conf.d"
default['beaver']['log_dir'] = "/var/log/beaver"
default['beaver']['pid_dir'] = "/var/run/beaver"

default['beaver']['pip_package'] = "beaver==31"
default['beaver']['redis_ip'] = "192.168.88.100"

default['beaver']['postfix_mail'] = "/var/log/mail.log"
default['beaver']['postfix_err'] = "/var/log/mail.err"
default['beaver']['chef_path'] = "/var/log/chef/client.log"
default['beaver']['postgres_path'] = "/var/log/postgresql/postgresql-9.1-main.log"
default['beaver']['kibana_access_path'] = "/var/log/nginx/kibana.access.log"
default['beaver']['kibana_error_path'] = "/var/log/nginx/kibana.error.log"

default['beaver']['redis_path'] = "/var/log/redis/redis-server.log"

default['beaver']['apache_ssl_access'] = "/var/log/apache2/access_log"
default['beaver']['apache_ssl_error'] = "/var/log/apache2/error_log"
default['beaver']['apache_access_path'] = "/var/log/apache2/access.log"
default['beaver']['apache_error_path'] = "/var/log/apache2/error.log"
