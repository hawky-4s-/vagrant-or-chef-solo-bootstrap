bootstrap files borrowed (stolen) from this tutorial  
[Chef Solo tutorial](http://opinionatedprogrammer.com/2011/06/chef-solo-tutorial-managing-a-single-server-with-chef/#comment-910)

If you are using this and you would like features added, create an issue or pull request (preferrably on a topic branch you have created in your fork)

#### Todo

* rbenv and ruby 1.9.3+
* zsh, maybe with my .oh-my-zsh repo

##nodes
* infrastructure
* app server


##roles
* email
* ldap
* apache2 / nginx
* development -> nexus, jenkins, sonar?
* appserver
* database

servers:

infrastructure:
    email (dovecot)
    ldap master
    apache2 (replace with nginx)
    nexus
    jenkins
    sonar?

production
    login with ldap
    jboss eap 6.1



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



role:
name "web_server"
description "A basic web server"
run_list "recipe[datacenter]", "recipe[nginx]"



ebooks:

http://geek-book.org/book/instant-osgi-starter
http://geek-book.org/book/data-analytics-models-and-algorithms-for-intelligent-data-analysis
http://geek-book.org/book/soa-made-simple
http://geek-book.org/book/continuous-delivery-and-devops-a-quickstart-guide
http://geek-book.org/book/test-driven-infrastructure-with-chef
http://geek-book.org/book/akka-essentials
http://geek-book.org/book/instant-sublime-text-starter
http://geek-book.org/book/apache-tomcat-7-essentials

