default['logstash']['server']['version'] = '1.3.3'
default['logstash']['server']['source_url'] = 'https://download.elasticsearch.org/logstash/logstash/logstash-1.3.3-flatjar.jar'
default['logstash']['server']['checksum'] = '6ef146931eb8d4ad3f1b243922626923'


#heap size for upstart
default['logstash']['server']['xms'] = '512M'
default['logstash']['server']['xmx'] = '512M'
default['logstash']['server']['debug'] = false
