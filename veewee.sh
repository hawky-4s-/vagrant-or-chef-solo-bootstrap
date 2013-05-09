#!/bin/bash


# https://github.com/Jimdo/veewee-definitions
# https://github.com/jedi4ever/veewee/blob/master/doc/vagrant.md

# requires ruby

libxslt1-dev
libxml2-dev
zlib1g-dev # or build-essential



cd <path_to_workspace>
$ git clone https://github.com/jedi4ever/veewee.git
$ cd veewee


 rbenv local 1.9.2-p392
$ rbenv rehash

$ gem install bundler
$ rbenv rehash
$ bundle install
$ rbenv rehash


#$ bundle exec veewee

echo "alias veewee='bundle exec veewee'" >> ~/.bash_profile