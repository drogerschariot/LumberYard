#
# Locations
#

default['redis']['conf_path'] = '/etc/redis'
default['redis']['run_path'] = '/var/run/redis'
default['redis']['log_path'] = '/var/log/redis'
default['redis']['pid'] = 'redis.pid'

default['redis']['user'] = 'redis'
default['redis']['group'] = 'redis'

#
# Server
#

default['redis']['bind'] = "0.0.0.0"
default['redis']['port'] = "6379"