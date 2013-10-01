#!/usr/bin/env sh

VAGRANT_GITHUB="mitchellh/vagrant"
VAGRANT_VERSION=$(curl -s https://api.github.com/repos/${VAGRANT_GITHUB}/git/refs/tags \
| ruby -rjson -e '
  j = JSON.parse(STDIN.read);
  version = j.map { |t| t["ref"].split("/").last }.sort.last
  puts version[1, version.length]
')

echo ${VAGRANT_VERSION}

VAGRANT_RELEASE_UUID=$(curl -s https://api.github.com/repos/${VAGRANT_GITHUB}/git/refs/tags \
| ruby -rjson -e '
  j = JSON.parse(STDIN.read);
  version = j.map { |t| t["ref"].split("/").last }.sort.last
  puts j.find { |t| t["ref"].include? version }["object"]["sha"]
')

echo ${VAGRANT_RELEASE_UUID}