# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.box = "Ubuntu-Server-12.04.2-x86_64-minimal"
  config.vm.box_url = "http://puppet-vagrant-boxes.puppetlabs.com/ubuntu-server-12042-x64-vbox4210-nocm.box"

  #config.vm.box = "Berkshelf-CentOS-6.3-x86_64-minimal"
  #config.vm.box_url = "https://dl.dropbox.com/u/31081437/Berkshelf-CentOS-6.3-x86_64-minimal.box"

  #config.omnibus.chef_version = :latest
  config.ssh.max_tries = 40
  config.ssh.timeout = 120

  # Assign this VM to a host only network IP, allowing you to access it
  # via the IP.
  # config.vm.network "33.33.33.10"
  #config.vm.forward_port 80, 8080
  #config.vm.forward_port 22, 2222
  #config.vm.network :forwarded_port, guest: 8080, host: 8080

  # if you want to set up multiple instances at the same time,
  # you can name them (:web and :gridfs below) and refer to them
  # in your vagrant commands
  #
  # vagrant provision web
  # vagrant provision gridfs
  # vagrant reload gridfs
  # ...
  # as per the vagrant documentation, you should
  # choose IPs that will not clash with your local
  # network
  # 192.168.2.100 # bad
  # 22.22.22.22 # unbad
  #
  #config.vm.define :web do |web_config|
    #web_config.vm.box = box
    #web_config.vm.forward_port(80, 8080)
    #web_config.vm.network :hostonly, "22.22.22.22"
  #end
#
  #config.vm.define :gridfs do |db_config|
    #db_config.vm.box = box
    #db_config.vm.forward_port(27017, 27000)
    #db_config.vm.network :hostonly, "22.22.22.23"
  #end

  #config.vm.synced_folder "data", "/data"

  config.vm.provider :virtualbox do |vb|
    # Use VBoxManage to customize the VM.
    vb.customize ["modifyvm", :id, "--memory", "2048", "--cpus", "1"]

  end

  # Use [berkshelf](http://berkshelf.com/)
  config.berkshelf.enabled = true

  # web vm
  config.vm.define :web do |web_config|
    web_config.vm.network :private_network, ip: "33.33.33.33"
    web_config.vm.hostname = "livingoz.com"

    web_config.vm.provision :shell, :path => "install.sh"

    VAGRANT_JSON = MultiJson.load(Pathname(__FILE__).dirname.join('chef/nodes', 'vagrant.json').read)
    web_config.vm.provision :chef_solo do |chef|
      chef.roles_path = "chef/roles"
      chef.data_bags_path = "chef/data_bags"
      #chef.encrypted_data_bag_secret_key_path = "./data_bag_key"

      chef.add_role("common")
      # You may also specify custom JSON attributes:
      #chef.json = VAGRANT_JSON
      #VAGRANT_JSON['run_list'].each do |recipe|
      #  chef.add_recipe(recipe)
      #end if VAGRANT_JSON['run_list']
    end

    web_config.vm.network :forwarded_port, guest: 80, host: 8080
  end

  # production vm
  config.vm.define :prod do |prod_config|
    prod_config.vm.network :private_network, ip: "33.33.33.34"

    prod_config.vm.provision :shell, :path => "install.sh"
  end

  #config.vm.forward_port(80, 8080)
  #config.vm.forward_port(3000, 3030)
  #config.vm.network :hostonly, "22.22.22.22"

  #config.vm.provision :chef_solo do |chef|
   # chef.cookbooks_path = "chef/cookbooks"
    #chef.add_recipe "pferdefleisch"
    #chef.add_recipe "pferdefleisch::dotfiles"
    #chef.add_recipe "pferdefleisch::rbenv"
    #chef.add_recipe "pferdefleisch::postgresql"
    #chef.add_recipe "pferdefleisch::mlt"
    #chef.json = { :user => "vagrant" }
  #end

end
