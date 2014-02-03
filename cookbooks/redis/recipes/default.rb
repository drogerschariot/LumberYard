#
# Cookbook Name::       redis
# Description::         Base configuration for redis
# Recipe::              default
# Author::              Benjamin Black (<b@b3k.us>)
#
# Copyright 2009, Benjamin Black
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

package "redis-server" do
	action :install
end


group node['redis']['group'] do
  action :create
  system true
end


user node['redis']['user'] do
  action :create
  comment "Redis"
  system true
end

directory node['redis']['conf_path'] do
	owner node['redis']['user']
	group node['redis']['group']
	mode 00755
	action :create
end

directory node['redis']['run_path'] do
	owner node['redis']['user']
	group node['redis']['group']
	mode 00755
	action :create
end


template "#{node['redis']['conf_path']}/redis.conf" do
  owner node['redis']['user']
  group node['redis']['group']
  mode 0755
  source "redis.conf.erb"
  notifies :restart, "service[redis-server]"
end

service "redis-server" do
    action [ :enable ]
end