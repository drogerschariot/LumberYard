# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  
  # Redis
  config.vm.define :redis do |redis|
    # All Vagrant configuration is done here. The most common configuration
    # options are documented and commented below. For a complete reference,
    # please see the online documentation at vagrantup.com.

    # Every Vagrant virtual environment requires a box to build off of.
    redis.vm.box = "precise64"
    redis.vm.hostname = "redis"

    # The url from where the 'redis.vm.box' box will be fetched if it
    # doesn't already exist on the user's system.
    redis.vm.box_url = "http://files.vagrantup.com/precise64.box"

    # Create a forwarded port mapping which allows access to a specific port
    # within the machine from a port on the host machine. In the example below,
    # accessing "localhost:8080" will access port 80 on the guest machine.
    redis.vm.network :forwarded_port, guest: 6379, host: 6379

    # Create a private network, which allows host-only access to the machine
    # using a specific IP.
    redis.vm.network :private_network, ip: "192.168.88.100"

    # Create a public network, which generally matched to bridged network.
    # Bridged networks make the machine appear as another physical device on
    # your network.
    # redis.vm.network :public_network

    # If true, then any SSH connections made will enable agent forwarding.
    # Default value: false
    redis.ssh.forward_agent = true

    # Share an additional folder to the guest VM. The first argument is
    # the path on the host to the actual folder. The second argument is
    # the path on the guest to mount the folder. And the optional third
    # argument is a set of non-required options.
    # redis.vm.synced_folder "../data", "/vagrant_data"

    # Provider-specific redisuration so you can fine-tune various
    # backing providers for Vagrant. These expose provider-specific options.
    # Example for VirtualBox:
    #
    # redis.vm.provider :virtualbox do |vb|
    #   # Don't boot with headless mode
    #   vb.gui = true
    #
    #   # Use VBoxManage to customize the VM. For example to change memory:
    #   vb.customize ["modifyvm", :id, "--memory", "1024"]
    # end
    #
    # View the documentation for the provider you're using for more
    # information on available options.

    # Enable provisioning with Puppet stand alone.  Puppet manifests
    # are contained in a directory path relative to this Vagrantfile.
    # You will need to create the manifests directory and a manifest in
    # the file precise64.pp in the manifests_path directory.
    #
    # An example Puppet manifest to provision the message of the day:
    #
    # # group { "puppet":
    # #   ensure => "present",
    # # }
    # #
    # # File { owner => 0, group => 0, mode => 0644 }
    # #
    # # file { '/etc/motd':
    # #   content => "Welcome to your Vagrant-built virtual machine!
    # #               Managed by Puppet.\n"
    # # }
    #
    # redis.vm.provision :puppet do |puppet|
    #   puppet.manifests_path = "manifests"
    #   puppet.manifest_file  = "site.pp"
    # end

    # Enable provisioning with chef solo, specifying a cookbooks path, roles
    # path, and data_bags path (all relative to this Vagrantfile), and adding
    # some recipes and/or roles.
    #
    # redis.vm.provision :chef_solo do |chef|
    #   chef.cookbooks_path = "../my-recipes/cookbooks"
    #   chef.roles_path = "../my-recipes/roles"
    #   chef.data_bags_path = "../my-recipes/data_bags"
    #   chef.add_recipe "mysql"
    #   chef.add_role "web"
    #
    #   # You may also specify custom JSON attributes:
    #   chef.json = { :mysql_password => "foo" }
    # end

    redis.vm.provision "chef_solo" do |chef|
      chef.add_recipe "apt"
      chef.add_recipe "build-essential"
      chef.add_recipe "redis"
      chef.add_recipe "vim"
    end

    # Enable provisioning with chef server, specifying the chef server URL,
    # and the path to the validation key (relative to this Vagrantfile).
    #
    # The Opscode Platform uses HTTPS. Substitute your organization for
    # ORGNAME in the URL and validation key.
    #
    # If you have your own Chef Server, use the appropriate URL, which may be
    # HTTP instead of HTTPS depending on your redisuration. Also change the
    # validation key to validation.pem.
    #
    # redis.vm.provision :chef_client do |chef|
    #   chef.chef_server_url = "https://api.opscode.com/organizations/ORGNAME"
    #   chef.validation_key_path = "ORGNAME-validator.pem"
    # end
    #
    # If you're using the Opscode platform, your validator client is
    # ORGNAME-validator, replacing ORGNAME with your organization name.
    #
    # If you have your own Chef Server, the default validation client name is
    # chef-validator, unless you changed the configuration.
    #
    #   chef.validation_client_name = "ORGNAME-validator"
  end

  # The Rest of the VM definitions will not have the base comments :)

  # Test VM (Optional)
  #config.vm.define :test do |test|

    #test.vm.box = "precise64"
    #test.vm.hostname = "test"
    #test.vm.box_url = "http://files.vagrantup.com/precise64.box"
    #test.vm.network :private_network, ip: "192.168.88.102"
    #test.ssh.forward_agent = true
#
    #test.vm.provision "chef_solo" do |chef|
    #  chef.add_recipe "apt"
    #  chef.add_recipe "build-essential"
    #  chef.add_recipe "vim"
    #  chef.add_recipe "python"
    #  chef.add_recipe "beaver"
    #end
  #end


  # Logstash
  config.vm.define :logstash do |logstash|

    logstash.vm.box = "precise64"
    logstash.vm.hostname = "logstash"
    logstash.vm.box_url = "http://files.vagrantup.com/precise64.box"
    logstash.vm.provider "virtualbox" do |v|
      v.memory = 1024
    end

    logstash.vm.network :private_network, ip: "192.168.88.101"
    logstash.vm.network :forwarded_port, guest: 9300, host: 9300
    logstash.vm.network :forwarded_port, guest: 9200, host: 9200
    logstash.vm.network :forwarded_port, guest: 8088, host: 8088
    logstash.ssh.forward_agent = true

    logstash.vm.provision "chef_solo" do |chef|
      chef.add_recipe "apt"
      chef.add_recipe "build-essential"
      chef.add_recipe "vim"
      chef.add_recipe "java"
      chef.add_recipe "nginx"
      chef.add_recipe "logstash"
      chef.add_recipe "logstash::kibana"
    end

    logstash.vm.provision "shell",
      inline: "service logstash_server restart"
  end

end
