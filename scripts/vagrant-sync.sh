#!/bin/bash
set -ex

contrib/vagrant/sync_config.sh

make all

for VM in `vagrant status | grep running | cut -d " " -f1`; do
  vagrant rsync $VM # if you do not use NFS
  vagrant ssh $VM -c "cd /vagrant && sudo hack/build-docker.sh"
done

export KUBECTL="contrib/vagrant/kubectl.sh --core"

cluster/deploy.sh
