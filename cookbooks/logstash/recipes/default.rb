#
# Cookbook Name:: logstash
# Recipe:: default
#
# LumberYard Copyright 2013, Drew Rogers <drogers@chariotsolutions.com>
#
# All rights reserved - Do Not Redistribute
#

include_recipe "java"
postfix_pattern = "# Source:  https://gist.github.com/jamtur01/4385667/raw/3be6ce01014483eac71368f9525da329fe05ff6d/postfix_patterns


# Syslog stuff
COMPONENT ([\w._\/%-]+)
COMPID postfix\/%{COMPONENT:component}(?:\[%{POSINT:pid}\])?
POSTFIX %{SYSLOGTIMESTAMP:timestamp} %{SYSLOGHOST:hostname} %{COMPID}: %{QUEUEID:queueid}

# Postfix stuff
QUEUEID (?:[A-F0-9]+|NOQUEUE)
EMAILADDRESSPART [a-zA-Z0-9_.+-=:]+
EMAILADDRESS %{EMAILADDRESSPART:local}@%{EMAILADDRESSPART:remote}
RELAY (?:%{HOSTNAME:relayhost}(?:\[%{IP:relayip}\](?::[0-9]+(.[0-9]+)?)?)?)
#RELAY (?:%{HOSTNAME:relayhost}(?:\[%{IP:relayip}\](?:%{POSREAL:relayport})))
POSREAL [0-9]+(.[0-9]+)?
#DELAYS %{POSREAL:a}/%{POSREAL:b}/%{POSREAL:c}/%{POSREAL:d}
DELAYS (%{POSREAL}[/]*)+
DSN %{NONNEGINT}.%{NONNEGINT}.%{NONNEGINT}
STATUS sent|deferred|bounced|expired
PERMERROR 5[0-9]{2}
MESSAGELEVEL reject|warning|error|fatal|panic

POSTFIXSMTPMESSAGE %{MESSAGELEVEL}: %{GREEDYDATA:reason}
POSTFIXACTION discard|dunno|filter|hold|ignore|info|prepend|redirect|replace|reject|warn

# postfix/smtp and postfix/lmtp, postfix/local and postfix/error
POSTFIXSMTP %{POSTFIXSMTPRELAY}|%{POSTFIXSMTPCONNECT}|%{POSTFIXSMTP5XX}|%{POSTFIXSMTPREFUSAL}|%{POSTFIXSMTPLOSTCONNECTION}|%{POSTFIXSMTPTIMEOUT}
POSTFIXSMTPRELAY %{QUEUEID:qid}: to=<%{EMAILADDRESS:to}>,(?:\sorig_to=<%{EMAILADDRESS:orig_to}>,)? relay=%{RELAY},(?: conn_use=%{POSREAL:conn_use},)? delay=%{POSREAL:delay}, delays=%{DELAYS:delays}, dsn=%{DSN}, status=%{STATUS:result} %{GREEDYDATA:reason}
POSTFIXSMTPCONNECT connect to %{RELAY}: %{GREEDYDATA:reason}
POSTFIXSMTP5XX %{QUEUEID:qid}: to=<%{EMAILADDRESS:to}>,(?:\sorig_to=<%{EMAILADDRESS:orig_to}>,)? relay=%{RELAY}, delay=%{POSREAL:delay}, delays=%{DELAYS:delays}, dsn=%{DSN}, status=%{STATUS:result} \(host %{HOSTNAME}\[%{IP}\] said: %{PERMERROR:responsecode} %{DATA:smtp_response} \(in reply to %{DATA:command} command\)\)
POSTFIXSMTPREFUSAL %{QUEUEID:qid}: host %{RELAY} refused to talk to me: %{GREEDYDATA:reason}
POSTFIXSMTPLOSTCONNECTION %{QUEUEID:qid}: lost connection with %{RELAY} while %{GREEDYDATA:reason}
POSTFIXSMTPTIMEOUT %{QUEUEID:qid}: conversation with %{RELAY} timed out while %{GREEDYDATA:reason}


# postfix/smtpd
POSTFIXSMTPD %{POSTFIXSMTPDCONNECTS}|%{POSTFIXSMTPDMILTER}|%{POSTFIXSMTPDACTIONS}|%{POSTFIXSMTPDTIMEOUTS}|%{POSTFIXSMTPDLOGIN}|%{POSTFIXSMTPDCLIENT}|%{POSTFIXSMTPDNOQUEUE}|%{POSTFIXSMTPDWARNING}|%{POSTFIXSMTPDLOSTCONNECTION}
POSTFIXSMTPDCONNECTS (?:dis)?connect from %{RELAY}
POSTFIXSMTPDMILTER %{MILTERCONNECT}|%{MILTERUNKNOWN}|%{MILTEREHLO}|%{MILTERMAIL}|%{MILTERHELO}|%{MILTERRCPT}
POSTFIXSMTPDACTIONS %{QUEUEID:qid}: %{POSTFIXACTION}: %{DATA:command} from %{RELAY}: %{DATA:smtp_response}: %{DATA:reason}; from=<%{EMAILADDRESS:from}> to=<%{EMAILADDRESS:to}> proto=%{DATA:proto} helo=<%{HELO}>
POSTFIXSMTPDTIMEOUTS timeout after %{DATA:command} from %{RELAY}
POSTFIXSMTPDLOGIN %{QUEUEID:qid}: client=%{DATA:client}, sasl_method=%{DATA:saslmethod}, sasl_username=%{GREEDYDATA:saslusername}
POSTFIXSMTPDCLIENT %{QUEUEID:qid}: client=%{GREEDYDATA:client}
POSTFIXSMTPDNOQUEUE NOQUEUE: %{POSTFIXACTION}: %{DATA:command} from %{RELAY}: %{GREEDYDATA:reason}
POSTFIXSMTPDWARNING warning: %{IP}: %{GREEDYDATA:reason}
POSTFIXSMTPDLOSTCONNECTION lost connection after %{DATA:smtp_response} from %{RELAY}

# postfix/cleanup
POSTFIXCLEANUP %{POSTFIXCLEANUPMESSAGE}|%{POSTFIXCLEANUPMILTER}
POSTFIXCLEANUPMESSAGE %{QUEUEID:qid}: (resent-)?message-id=<%{GREEDYDATA:messageid}>
POSTFIXCLEANUPMILTER %{MILTERENDOFMESSAGE}

# postfix/bounce
POSTFIXBOUNCE %{QUEUEID:qid}: sender non-delivery notification: %{QUEUEID:bouncequeueid}

# postfix/qmgr and postfix/pickup
POSTFIXQMGR %{QUEUEID:qid}: (?:removed|from=<(?:%{EMAILADDRESS:from})?>(?:, size=%{POSINT:size}, nrcpt=%{POSINT:nrcpt} \(%{GREEDYDATA:queuestatus}\))?)

# postfix/anvil
POSTFIXANVIL statistics: %{DATA:anvilstatistic} for (%{DATA:remotehost}) at %{SYSLOGTIMESTAMP:timestamp}"

# Create system user to run logstash, if not, then root
if node['logstash']['create_account']

  group node['logstash']['group'] do
    system true
  end

  user node['logstash']['user'] do
    group node['logstash']['group']
    home "/var/lib/logstash"
    system true
    action :create
    manage_home true
  end
else
  node.default['logstash']['user'] = 'root'
  node.default['logstash']['group'] = 'root'
end

  # Create base dir
  directory node['logstash']['base_dir'] do
	  action :create
	  owner node['logstash']['user']
  	group node['logstash']['group']
	  mode "0755"
  end

  # Create config dir 
  directory node['logstash']['config_dir'] do
    owner node['logstash']['user']
    group node['logstash']['group']
    mode "0750"
    action :create
  end

  # Create log dir 
  directory node['logstash']['log_dir'] do
    owner node['logstash']['user']
    group node['logstash']['group']
    mode "0755"
    action :create
  end

  # Create run dir 
  directory node['logstash']['pid_dir'] do
    owner node['logstash']['user']
    group node['logstash']['group']
    mode "0755"
    action :create
  end

  # Install Logstash
  remote_file "#{node['logstash']['base_dir']}/logstash-#{node['logstash']['version']}.jar" do
    owner node['logstash']['user']
    group node['logstash']['group']
    mode "0755"
    source node['logstash']['source_url']
    checksum node['logstash']['checksum']
    action :create_if_missing
  end

  link "#{node['logstash']['base_dir']}/logstash.jar" do
    to "#{node['logstash']['base_dir']}/logstash-#{node['logstash']['version']}.jar"
    notifies :restart, "service[logstash_server]"
  end

  # Config File
  template "#{node['logstash']['config_dir']}/logstash.conf" do
    source "logstash.conf.erb"
    owner node['logstash']['user']
    group node['logstash']['group']
    mode "0644"
    variables(:es_server_ip =>  node['logstash']['elasticsearch_ip'], 
              :redis_ip => node['logstash']['redis_ip'] )
    notifies :restart, "service[logstash_server]"
    action :create
  end

    # Create custon grok pattern for postfix
  directory "#{node['logstash']['base_dir']}/patterns" do
    owner node['logstash']['user']
    group node['logstash']['group']
    mode "0755"
    action :create
  end
  
  # Upstart config
  template "/etc/init/logstash_server.conf" do
    mode "0644"
    source "logstash_server.conf.erb"
    notifies :restart, "service[logstash_server]"
  end
  
  service "logstash_server" do
    provider Chef::Provider::Service::Upstart
    action [ :enable, :start ]
end	
