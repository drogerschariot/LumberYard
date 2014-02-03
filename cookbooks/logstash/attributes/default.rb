default['logstash']['base_dir'] = '/opt/logstash'
default['logstash']['create_account'] = true
default['logstash']['user'] = 'logstash'
default['logstash']['group'] = 'logstash'
default['logstash']['config_dir'] = '/etc/logstash'
default['logstash']['log_dir'] = '/var/log/logstash'
default['logstash']['pid_dir'] = '/var/run/logstash'

default['logstash']['elasticsearch_ip'] = '127.0.0.1'
default['logstash']['elasticsearch_port'] = '9200'
default['logstash']['redis_ip'] = '192.168.88.100'

#Download logstash
default['logstash']['version'] = '1.3.3'
default['logstash']['source_url'] = 'https://download.elasticsearch.org/logstash/logstash/logstash-1.3.3-flatjar.jar'
default['logstash']['checksum'] = '6ef146931eb8d4ad3f1b243922626923'

#heap size for upstart
default['logstash']['xms'] = '512M'
default['logstash']['xmx'] = '512M'

