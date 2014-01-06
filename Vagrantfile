# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  #config.vm.box = 'Ubuntu-Server-12.04.2-x86_64-minimal'
  #config.vm.box_url = 'http://puppet-vagrant-boxes.puppetlabs.com/ubuntu-server-12042-x64-vbox4210-nocm.box'
  #config.vm.box.url = 'http://nitron-vagrant.s3-website-us-east-1.amazonaws.com/vagrant_ubuntu_12.04.3_amd64_virtualbox.box'

  config.vm.box.url = 'http://cloud-images.ubuntu.com/vagrant/precise/current/precise-server-cloudimg-amd64-vagrant-disk1.box'
  config.vm.box = 'strato-big'
  #config.vm.box.url = 'http://cloud-images.ubuntu.com/vagrant/precise/current/precise-server-cloudimg-i386-vagrant-disk1.box'

  # configure vagrant plugins
  config.omnibus.chef_version = :latest
  config.berkshelf.enabled = true
  config.cache.auto_detect = true

  config.ssh.max_tries = 40
  config.ssh.timeout = 120

  config.vm.provider :virtualbox do |vb|
    # Use VBoxManage to customize the VM.
    vb.customize ['modifyvm', :id, '--memory', '3072', '--cpus', '2']

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

    web_config.vm.network :forwarded_port, guest: 80, host: 8080
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
