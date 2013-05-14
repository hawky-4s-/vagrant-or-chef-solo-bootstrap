bootstrap:

* create dev environment (ruby, virtualbox, berkshelf, vagrant, veewee) on local workstation
** workflow
bootstrap.sh


* create veewee template (ruby, chef/(puppet), virtualbox guest additions)
** workflow



* create vagrant box via chef-solo (uses Vagrantfile) / configure strato vserver with chef-solo
** workflow
deploy.sh -> install.sh -> base.sh + common.sh + ruby.sh + chef.sh + execute chef-solo