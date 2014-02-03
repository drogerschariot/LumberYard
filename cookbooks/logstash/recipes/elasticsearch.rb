#
# Cookbook Name:: logstash
# Recipe::
#
# LumberYard Copyright 2013, Drew Rogers <drogers@chariotsolutions.com>
#
# Installs the Logstash server
#

#include_recipe "logsatash"

# Create syste, user if create_account is true, else run as root
if node['logstash']['elasticsearch']['create_account']
	group node['logstash']['elasticsearch']['group'] do
		system true
	end

	user node['logstash']['elasticsearch']['user'] do
		group node['logstash']['elasticsearch']['group']
	    home "/var/lib/elasticsearch"
	    system true
	    action :create
	    manage_home true
	end
else
	node['logstash']['elasticsearch']['user'] = 'root'
	node['logstash']['elasticsearch']['group'] = 'root'
end

# Install Elasticsearch
directory node['logstash']['elasticsearch']['base_dir'] do
	owner node['logstash']['elasticsearch']['user']
	group node['logstash']['elasticsearch']['group']
	mode 00755
	action :create
end

directory node['logstash']['elasticsearch']['log_dir'] do
	owner node['logstash']['elasticsearch']['user']
	group node['logstash']['elasticsearch']['group']
	mode 00755
	action :create
end

# Install data directory

directory '/data' do
	owner 'root'
	group 'root'
	mode 00755
	action :create
end

directory node['logstash']['elasticsearch']['data_dir'] do
	owner node['logstash']['elasticsearch']['user']
	group node['logstash']['elasticsearch']['group']
	mode 00750
	action :create
end

# Create config to increase ulimit
template "/etc/security/limits.d/#{node['logstash']['elasticsearch']['user']}.conf" do
	source "limits.conf.erb"
	owner "root"
	group "root"
	mode 00644
end


remote_file "/tmp/elasticsearch-#{node['logstash']['elasticsearch']['version']}.tar.gz" do
	owner node['logstash']['elasticsearch']['user']
	group node['logstash']['elasticsearch']['group']
	mode "0755"
	source node['logstash']['elasticsearch']['source_url']
	checksum node['logstash']['elasticsearch']['checksum']
	action :create_if_missing
end

execute "unpack elasticsearch" do
	command "tar -zxf elasticsearch-#{node['logstash']['elasticsearch']['version']}.tar.gz -C #{node['logstash']['elasticsearch']['base_dir']} --strip-components 1"
	cwd "/tmp"
	user node['logstash']['elasticsearch']['user']
	action :run
	not_if { File.exists?("#{node['logstash']['elasticsearch']['base_dir']}/config") }
end

template "#{node['logstash']['elasticsearch']['base_dir']}/config/elasticsearch.yml" do
	mode "0744"
	source "elasticsearch.yml.erb"
	owner node['logstash']['elasticsearch']['user']
	group node['logstash']['elasticsearch']['group']
	notifies :restart, "service[elasticsearch_server]"
end

# Upstart config
template "/etc/init/elasticsearch_server.conf" do
	mode "0644"
	source "elasticsearch_server.conf.erb"
end

service "elasticsearch_server" do
	provider Chef::Provider::Service::Upstart
	action [ :enable ]
end	