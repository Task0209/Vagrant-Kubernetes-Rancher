# -*- mode: ruby -*-
# vi: set ft=ruby :
MASTER_IP       = "192.168.0.50"
NODE_01_IP      = "192.168.0.51"
NODE_02_IP      = "192.168.0.52"
RANCHER_IP      = "192.168.0.53"

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/focal64"

  boxes = [
    { :name => "master",  :ip => MASTER_IP,  :cpus => 2, :memory => 4096 },
    { :name => "workernode-01", :ip => NODE_01_IP, :cpus => 2, :memory => 4096 },
    { :name => "workernode-02", :ip => NODE_02_IP, :cpus => 2, :memory => 4096 },
    { :name => "rancher", :ip => RANCHER_IP, :cpus => 2, :memory => 4096 },
  ]

  boxes.each do |opts|
    config.vm.define opts[:name] do |box|
      box.vm.hostname = opts[:name]
      box.vm.network :public_network, ip: opts[:ip]
 
      box.vm.provider "virtualbox" do |vb|
        vb.cpus = opts[:cpus]
        vb.memory = opts[:memory]
      end
      
      if box.vm.hostname == "master" then 
        box.vm.provision "shell", path:"./install-kubernetes-dependencies.sh"
        box.vm.provision "shell", path:"./configure-master-node.sh"
        end
      if box.vm.hostname == "workernode-01" then ##TODO: create some regex to match worker hostnames
        box.vm.provision "shell", path:"./install-kubernetes-dependencies.sh"
        box.vm.provision "shell", path:"./configure-worker-nodes.sh"
      end
      if box.vm.hostname == "workernode-02" then ##TODO: create some regex to match worker hostnames
        box.vm.provision "shell", path:"./install-kubernetes-dependencies.sh"
        box.vm.provision "shell", path:"./configure-worker-nodes.sh"
      end
      if box.vm.hostname == "rancher" then ##TODO: create some regex to match worker hostnames
        box.vm.provision "shell", path:"./install-rancher-dependencies.sh"
        box.vm.provision "shell", path:"./rancher-setup.sh"
      end
    end
  end

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # NOTE: This will enable public access to the opened port
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine and only allow access
  # via 127.0.0.1 to disable public access
  # config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
  #   vb.memory = "1024"
  # end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Enable provisioning with a shell script. Additional provisioners such as
  # Ansible, Chef, Docker, Puppet and Salt are also available. Please see the
  # documentation for more information about their specific syntax and use.
  # config.vm.provision "shell", inline: <<-SHELL
  #   apt-get update
  #   apt-get install -y apache2
  # SHELL
end
