bootstrap files borrowed (stolen) from this tutorial  
[Chef Solo tutorial](http://opinionatedprogrammer.com/2011/06/chef-solo-tutorial-managing-a-single-server-with-chef/#comment-910)

If you are using this and you would like features added, create an issue or pull request (preferrably on a topic branch you have created in your fork)

#### Todo
* think about using variable to switch between vagrant/veewee or strato build


* rbenv and ruby 1.9.3+
* zsh, maybe with my .oh-my-zsh repo

##nodes
* infrastructure
* app server


##roles
* mail
* ldap
* apache2 / nginx
* development -> nexus, jenkins, sonar?
* appserver
* database

servers:

infrastructure:
    mail (dovecot)
    ldap master
    apache2 (replace with nginx)
    nexus
    jenkins
    sonar?

production
    login with ldap
    jboss eap 6.1

ports:

25 (SMTP), 80 (HTTP), 110 (POP3), 143 (IMAP), 443 (HTTPS), 465 (SMTPS), 993 (IMAPS), and 995 (POP3S).

http://learnchef.getharvest.com/


Environments -> group of Nodes, has attributes
Nodes -> one or more Roles, has attributes
Roles -> one or more Cookbooks, has attributes
Cookbooks -> one or more Recipes, Templates, Files..., has attributes



environments:

development
staging
production

{
 "name": "production_rackspace",
 "description": "Rackspace Servers",
 "json_class": "Chef::Environment",
 "chef_type": "environment",
 "override_attributes": {
   "datacenter": "rackspace"
 }
}


ohai - attributes like ip, processors, os etc. -> http://wiki.opscode.com/display/chef/Ohai

cpu_cores = node[:cpu][:total]

package "libpcre3-dev" do
  unless node[:ec2]
    action :upgrade
  end
end


ebooks:

http://geek-book.org/book/instant-osgi-starter
http://geek-book.org/book/data-analytics-models-and-algorithms-for-intelligent-data-analysis
http://geek-book.org/book/soa-made-simple
http://geek-book.org/book/continuous-delivery-and-devops-a-quickstart-guide
http://geek-book.org/book/test-driven-infrastructure-with-chef
http://geek-book.org/book/akka-essentials
http://geek-book.org/book/instant-sublime-text-starter
http://geek-book.org/book/apache-tomcat-7-essentials

#bootstrap development env
* git
* virtualbox
* rvm/rbenv
* ruby
* berkshelf
* (foodcritic)
* vagrant
* vagrant berkshelf plugin
#chef-solo

#check for running in vagrant
if node[:instance_role] == 'vagrant'
  # do something that should only be done inside
  # a Vagrant box
end

#speed up downloads in vagrant boxes
config.vm.provision :shell, :inline => "sed -i 's/us.archive/de.archive/g' /etc/apt/sources.list"


##### JBOSS
LOLWAT
 
## What you Get
- A working linux box
- Java JDK 1.6.0_xx
- JBoss 5.x.x
- Jenkins with Yale-Maven-Application-Installer
 
## The deets
- JBoss:
-- Installed JBOSS_HOME=/usr/local/jboss-eap-.....
-- Apps/Nodes = /usr/local/jboss-apps
-- Init script, per app = /etc/init.d/jboss_nodeXX
-- Config for node = /etc/sysconfig/jboss_nodeXX
-- From outside the VM: http://localhost:8080
 
- Jenkins:
-- Installed in /usr/local/jenkins
-- JENKINS_HOME=/usr/local/jenkins/JENKINS_HOME
-- Init script = /etc/init.d/jenkins
-- Basic Config in /etc/sysconfig/jenkins
-- No jobs currently setup... to be conntinued
-- From outside the VM: http://localhost:8888
 
 
## How to get rolling
 
-- Install Virtualbox
https://www.virtualbox.org/wiki/Downloads
 
-- Install a git client if you don't have one
 
-- Install Vagrant
http://vagrantup.com/
 
-- Setup box
cd ~/tmp/vagrant_projects
git clone git://gist.github.com/2997552.git jboss512-vagrant
cd jboss512-vagrant
 
-- Setup some shared folders
mkdir -p jboss/jboss-apps jboss/jboss-logs jboss/jboss-deploy
 
-- get a copy of my chef cookbooks
git clone git://github.com/fishnix/chef-repo-yu.git -b vagrant-cookbooks
 
-- Fire and go
vagrant up

###################

# -*- mode: ruby -*-
# vi: set ft=ruby :
 
Vagrant::Config.run do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.
 
  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "centos62min"
  config.vm.box_url = "http://leleupi.its.yale.edu:8181/PKG/centos62min.box"
  config.vm.customize ["modifyvm", :id, "--memory", "1024"]
 
  # Forward a port from the guest to the host, which allows for outside
  # computers to access the VM, whereas host only networking does not.
  
  # JBoss node00 ports
  config.vm.forward_port 8080, 8080 # HTTP
  config.vm.forward_port 8440, 8440 # HTTPS
  config.vm.forward_port 8780, 8780 # DEBUG
  
  # JBoss node01 ports
  config.vm.forward_port 8180, 8180 # HTTP
  config.vm.forward_port 8441, 8441 # HTTPS
  config.vm.forward_port 8781, 8781 # DEBUG
  
  # Jenkins HTTP
  config.vm.forward_port 8888, 8888
  
  # SSH
  config.vm.forward_port 22, 2222
  # Enable provisioning with chef solo, specifying a cookbooks path (relative
  # to this Vagrantfile), and adding some recipes and/or roles.
  
  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = "chef-repo-yu/cookbooks"
    chef.roles_path = "chef-repo-yu/roles"
    
    chef.add_role "jboss-vagrant"
  
    # You may also specify custom JSON attributes:
    chef.json.merge!({
                        :misc => {  :hostname => "vagrant-centos-62" },
                        :java => {  
                                    :tmpdir => "/vagrant/src",
                                    :jdk_url   => 'http://leleupi.its.yale.edu:8181/PKG/jdk1.6.0_33.tar.gz',
                                    :jdk_file  => 'jdk1.6.0_33.tar.gz',
                                    :java_home => '/usr/local/jdk1.6.0_33'
                                  },
                        :jenkins => { :user => "vagrant" },          
                        :jboss => { 
                                    :tmpdir => "/vagrant/src",
                                    :keystore_url => "http://leleupi.its.yale.edu:8181/PKG/server.keystore",
                                    :jboss_url   => 'http://leleupi.its.yale.edu:8181/PKG/jboss-eap-5.1.2.tar.gz',
                                    :jboss_file  => 'jboss-eap-5.1.2.tar.gz',
                                    :jboss_home  => '/usr/local/jboss-eap-5.1/jboss-as',
                                    :nodes => {  :node00 => { 
                                                              :user => "vagrant",
                                                              :additional_jboss_opts  => [ '-Djboss.proxyname=localhost','-Djboss.proxyport=8440'],
                                                              :additional_java_opts   => [ '-Xdebug',
                                                                                           '-Xrunjdwp:transport=dt_socket,address=8780,server=y,suspend=n' ]
                                                            },
                                                  :node01 => { 
                                                              :user => "vagrant",
                                                              :additional_jboss_opts  => [ '-Djboss.proxyname=localhost','-Djboss.proxyport=8441'],
                                                              :additional_java_opts   => [ '-Xdebug',
                                                                                           '-Xrunjdwp:transport=dt_socket,address=8781,server=y,suspend=n' ]
                                                              }
                                              }
                                  } 
                    })
   end
 
  # Share an additional folder to the guest VM. The first argument is
  # an identifier, the second is the path on the guest to mount the
  # folder, and the third is the path on the host to the actual folder.
  config.vm.share_folder "jboss-apps", "/usr/local/jboss-apps", "./jboss/jboss-apps"
  config.vm.share_folder "jboss-logs", "/var/log/jboss", "./jboss/jboss-logs"
  config.vm.share_folder "jboss-deploy", "/usr/local/jboss-deploy", "./jboss/jboss-deploy"
  
end


#######################################################





#interesting links
http://scriptogr.am/cbednarski/post/chef-berkshelf
http://misheska.com/
https://gist.github.com/wilmoore/1615295#file_install_virtualbox_latest_ubuntu.sh
https://github.com/fesplugas/rbenv-installer/blob/master/bin/rbenv-installer
http://vialstudios.com/guide-authoring-cookbooks.html

http://docs.opscode.com/essentials_cookbooks.html#Cookbooks-SiteSpecificCookbooks

http://ed.victavision.co.uk/blog/post/4-8-2012-chef-solo-encrypted-data-bags
http://ed.victavision.co.uk/blog/post/21-7-2012-chef-solo-data-bags
http://docs.opscode.com/essentials_data_bags_encrypt.html
http://docs.opscode.com/essentials_data_bags.html
https://gist.github.com/aaronjensen/4123044


# veewee
https://gist.github.com/jedi4ever
https://github.com/jimdo/veewee-definitions
