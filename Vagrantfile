# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.provision :shell, :path => "provision/common.sh"
  config.vm.provision :shell, :path => "provision/ansible.sh"

  config.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "2048"]
      vb.customize ["modifyvm", :id, "--cpus",   "2"]
      vb.customize ["guestproperty", "set", :id, "/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold", 60000]
  end

  config.vm.define 'dev' do |srv|
      srv.vm.hostname = 'naemon-dev.local'
      srv.vm.box      = "centos/7"
      # create bridged interface, vagrant will use the first existing interface from the list
      srv.vm.network "public_network", type: "dhcp", bridge: [
          "eth0",
          "en6: Broadcom NetXtreme Gigabit Ethernet Controller",
      ]
      srv.vm.network "private_network", ip: "192.168.99.99"
      config.vm.synced_folder ".", "/vagrant", type: "virtualbox"
  end
end
