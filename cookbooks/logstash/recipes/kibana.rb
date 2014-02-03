#
# Cookbook Name:: logstash
# Recipe:: kibana
#
# LumberYard Copyright 2013, Drew Rogers <drogers@chariotsolutions.com>
#
# Installs Kibana
#
# Depends: Nginx
#

# Make sure /var/www exists

directory "/var/www" do
	owner "root"
	group "root"
	mode "0755"
	action :create
end

directory "/var/www/nginx-default" do
	owner "root"
	group "root"
	mode "0755"
	action :create
end

package "unzip" do
	action :install
end



remote_file "/tmp/kibana-latest.zip" do
  owner "root"
  group "root"
  mode 00644
  source node['logstash']['kibana']['source_url']
  action :create_if_missing
end

execute "unzip kibana" do
	command "unzip kibana-latest.zip -d /var/www/nginx-default"
	cwd "/tmp"
	action :run
	creates "#{node['logstash']['kibana']['http_path']}/config.js"
end

link "#{node['logstash']['kibana']['http_path']}" do
	to "#{node['logstash']['kibana']['http_path']}-latest"
end

template "#{node['logstash']['kibana']['http_path']}/config.js" do
	source "config.js.erb"
	owner "root"
	group "root"
	mode 00744
	notifies :restart, "service[nginx]"
end

template "/etc/nginx/sites-available/default" do
	source "nginx.conf.erb"
	owner "root"
	group "root"
	mode 00744
end

service "nginx" do
    action [ :enable, :start ]
end	