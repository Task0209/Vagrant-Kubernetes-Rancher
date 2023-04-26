#!/bin/bash -e

IPADDR="192.168.0.50"
NODENAME=$(hostname -s)
POD_CIDR="10.244.0.0/16"


initialize_master_node ()
{
sudo systemctl enable kubelet
sudo kubeadm init --apiserver-advertise-address=$IPADDR  --apiserver-cert-extra-sans=$IPADDR  --pod-network-cidr=$POD_CIDR --node-name $NODENAME  --control-plane-endpoint=$IPADDR --ignore-preflight-errors=all
}

configure_kubectl () 
{
mkdir -p $HOME/.kube
sudo cp -f /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
}

create_join_command ()
{
config_path="/vagrant/configs"

if [ -d $config_path ]; then
  rm -f $config_path/*
else
  mkdir -p $config_path
fi

cp -i /etc/kubernetes/admin.conf $config_path/config
touch $config_path/join.sh
chmod +x $config_path/join.sh

kubeadm token create --print-join-command > $config_path/join.sh
}

install_network_cni ()
{
curl https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml -O
kubectl apply -f /home/vagrant/kube-flannel.yml

}

configure_vagrant_user ()
{
sudo -i -u vagrant bash << EOF
whoami
mkdir -p /home/vagrant/.kube
sudo cp -i $config_path/config /home/vagrant/.kube/
sudo chown 1000:1000 /home/vagrant/.kube/config
EOF
}

initialize_master_node
configure_kubectl
install_network_cni
create_join_command
configure_vagrant_user
