#!/bin/bash 

set -euxo pipefail

get_join_command ()
{
config_path="/vagrant/configs"

/bin/bash $config_path/join.sh -v
}

configure_vagrantuser()
{
sudo -i -u vagrant bash << EOF
whoami
mkdir -p /home/vagrant/.kube
sudo cp -i $config_path/config /home/vagrant/.kube/
sudo chown 1000:1000 /home/vagrant/.kube/config
NODENAME=$(hostname -s)
kubectl label node $(hostname -s) node-role.kubernetes.io/worker=worker
EOF
}

get_join_command
configure_vagrantuser
