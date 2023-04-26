#!/bin/bash -e

configure_sysctl ()
{
sudo apt update -y
sudo apt upgrade -y
sudo modprobe overlay
sudo modprobe br_netfilter
sudo tee /etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF
sudo sysctl --system
}

disable_swap () 
{
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
sudo swapoff -a
}

install_docker_runtime ()
{
sudo apt -y install curl apt-transport-https
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmour -o /etc/apt/trusted.gpg.d/docker.gpg
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt update
sudo apt install -y containerd.io docker-ce docker-ce-cli
sudo mkdir -p /etc/systemd/system/docker.service.d
sudo tee /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF

sudo systemctl daemon-reload 
sudo systemctl restart docker
sudo systemctl enable docker
sudo systemctl status docker

sudo usermod -aG docker ubuntu

id ubuntu

}


configure_hosts_file ()
{
sudo tee /etc/hosts<<EOF
192.168.0.50 master
192.168.0.51 workernode-01
192.168.0.52 workernode-02
EOF
}


install_kubernetes () 
{
sudo curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add

sudo apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"

sudo apt install kubeadm=1.21.0-00 kubectl=1.21.0-00 kubelet=1.21.0-00 -y

}


configure_sysctl
disable_swap
install_docker_runtime
configure_hosts_file
install_kubernetes
