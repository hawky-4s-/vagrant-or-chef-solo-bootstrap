# encoding: utf-8
# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.require_version ">= 1.4.3"

VAGRANTFILE_API_VERSION = "2"

Vagrant.require_plugin "vagrant-berkshelf"
Vagrant.require_plugin "vagrant-omnibus"
Vagrant.require_plugin "vagrant-cachier"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = 'Ubuntu-Server-12.04.x-x86_64-minimal'
  config.vm.box_url = 'http://cloud-images.ubuntu.com/vagrant/precise/current/precise-server-cloudimg-amd64-vagrant-disk1.box'

  config.vm.synced_folder = '/home/hawky4s/shared'
  config.ssh.forward_agent = true # forward ssh keys
  config.vm.boot_timeout = 120

  # configure vagrant plugins
  if Vagrant.has_plugin?("vagrant-cachier")
    config.cache.auto_detect = true
  end
  if Vagrant.has_plugin?("vagrant-omnibus")
    config.omnibus.chef_version = :latest
  end
  if Vagrant.has_plugin?("vagrant-berkshelf")
    config.berkshelf.enabled = true
  end

  config.vm.provider :virtualbox do |vb|
    # Use VBoxManage to customize the VM.
    vb.customize ['modifyvm', :id, '--memory', '4096', '--cpus', '2']
    vb.name = 'madbid-analytics'
  end

  # web vm
  config.vm.define :web do |web_config|
    web_config.vm.network :private_network, ip: '33.33.33.33'
    web_config.vm.hostname = 'livingoz.com'

    web_config.vm.provision :shell, :path => 'install.sh'



    VAGRANT_JSON = JSON.parse(Pathname(__FILE__).dirname.join('chef/nodes', 'vagrant.json').read)
    web_config.vm.provision :chef_solo do |chef|
      chef.roles_path = 'chef/roles'
      chef.data_bags_path = 'chef/data_bags'
      #chef.encrypted_data_bag_secret_key_path = "./data_bag_key"

      # You may also specify custom JSON attributes:
      chef.json = VAGRANT_JSON
      VAGRANT_JSON['run_list'].each do |recipe|
        chef.add_recipe(recipe)
      end if VAGRANT_JSON['run_list']

      #Dir["#{Pathname(__FILE__).dirname.join('chef/roles')}/*.json"].each do |role|
      #  chef.add_role(role)
      #end
    end

    web_config.vm.network :forwarded_port, guest: 8080, host: 8080
    web_config.vm.network :forwarded_port, guest: 8080, host: 8080
  end

  # production vm
  #config.vm.define :prod do |prod_config|
  #  prod_config.vm.network :private_network, ip: "33.33.33.34"
  #
  #  prod_config.vm.provision :shell, :path => "install.sh"
  #end

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
