default['logstash']['elasticsearch']['version'] = "0.90.9"
default['logstash']['elasticsearch']['base_dir'] = "/usr/local/elasticsearch-#{node['logstash']['elasticsearch']['version']}"
default['logstash']['elasticsearch']['pid_dir'] = "/var/run/elasticsearch"
default['logstash']['elasticsearch']['log_dir'] = "/var/log/elasticsearch"
default['logstash']['elasticsearch']['config_dir'] = "/etc/elasticsearch"
default['logstash']['elasticsearch']['data_dir'] = '/data/logstash_esdata' 
default['logstash']['elasticsearch']['user'] = 'elasticsearch'
default['logstash']['elasticsearch']['group'] = 'elasticsearch'
default['logstash']['elasticsearch']['create_account'] = true

default['logstash']['elasticsearch']['source_url'] = "https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-0.90.9.tar.gz"
default['logstash']['elasticsearch']['checksum'] = "dc193fedb210a5aa07e19594e1cd5ee0"

default['logstash']['elasticsearch']['min'] = "512M"
default['logstash']['elasticsearch']['max'] = "512M"

default['logstash']['elasticsearch']['cluster'] = "logstash"
default['logstash']['elasticsearch']['bind'] = "0.0.0.0"
default['logstash']['elasticsearch']['publish_interface'] = "eth1"

default['logstash']['elasticsearch']['ulimit_soft'] = '1000000'
default['logstash']['elasticsearch']['ulimit_hard'] = '1000000'