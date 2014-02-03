#
# Cookbook Name:: beaver
# Recipe:: default
#
# LumberYard Copyright 2013, Drew Rogers <drogers@chariotsolutions.com>
#
# Installs the Beaver agent to send logs to redis broker.
#

include_recipe "python::default"

# Create base dir
directory node['beaver']['base_dir'] do
	action :create
	owner 'root'
	group 'root'
	mode "0755"
end

# Create config dir 
directory node['beaver']['config_dir'] do
	owner 'root'
	group 'root'
	mode "0750"
	action :create
end

# Create config dir 
directory node['beaver']['configd_dir'] do
	owner 'root'
	group 'root'
	mode "0750"
	action :create
end

# Create log dir 
directory node['beaver']['log_dir'] do
	owner 'root'
	group 'root'
	mode "0755"
	action :create
end

# Create run dir 
directory node['beaver']['pid_dir'] do
	group 'root'
	mode "0755"
	action :create
end

# Install beaver via pip
python_pip node['beaver']['pip_package'] do
	action :install
end

# Create config files
template "#{node['beaver']['config_dir']}/beaver.conf" do
	source "beaver.conf.erb"
	owner "root"
	group "root"
	mode 00644
	notifies :restart, "service[beaver]"
end

template "/etc/init/beaver.conf" do
	source "beaver.erb"
	owner "root"
	group "root"
	mode 00644
	notifies :restart, "service[beaver]"
end

service "beaver" do
	supports :restart => true, :reload => true
	action [ :enable, :start ]
	provider Chef::Provider::Service::Upstart
end


