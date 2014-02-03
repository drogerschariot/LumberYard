#
# Cookbook Name::       redis
# Description::         Redis server with runit service
# Recipe::              server
# Author::              Benjamin Black
#
# Copyright 2011, Benjamin Black
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#


group node[:redis ][:user] do
  action :create
  gid node[:groups]['redis'][:gid]
  system true
end


user node[:redis ][:user] do
  action :create
  comment "Redis"
  uid node[:users ]['redis'][:uid]
  gid node[:groups]['redis'][:gid]
  system true
end


template "/etc/init/redis-server.conf" do
  owner "root"
  group "root"
  mode 0755
  source "redis-server.conf.erb"
  variables \
    port: node['redis']['server']['port'],
    bin: node['redis']['bin_dir'] + '/redis-server',
    cli: node['redis']['bin_dir'] + '/redis-cli',
    pid: node['redis']['pid_file'],
    conf: node['redis']['conf_dir'] + '/redis.conf'
end

service "redis-server" do
    provider Chef::Provider::Service::Upstart
    action [ :enable, :start ]
end