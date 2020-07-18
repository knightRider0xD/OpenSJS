# -*- mode: ruby -*-
# vi: set ft=ruby :

# Don't change, Vagrant API.
VAGRANT_API_VERSION = 2

# Local IP Address
IP = '192.168.70.70'

# Specs
CPUS = 2
MEMORY = 1024 * 6

def fail_with_message(msg)
  fail Vagrant::Errors::VagrantError.new, msg
end

Vagrant.configure(VAGRANT_API_VERSION) do |config|
  config.vm.box = "ubuntu/focal64"
  config.vm.box_url = "https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64-vagrant.box"
  config.vm.network :private_network, ip: IP, hostsupdater: 'skip'
  config.vm.hostname = 'suite.local'

  config.vm.synced_folder ".", "/vagrant"

  config.vm.provider 'virtualbox' do |vb|
    vb.name = config.vm.hostname
    vb.customize ['modifyvm', :id, '--cpus', CPUS]
    vb.customize ['modifyvm', :id, '--memory', MEMORY]

    # Fix for slow external network connections
    vb.customize ['modifyvm', :id, '--natdnshostresolver1', 'on']
    vb.customize ['modifyvm', :id, '--natdnsproxy1', 'on']

    # Sync NTP every 60 seconds to avoid drift
    vb.customize ["guestproperty", "set", :id, "/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold", 60000]

    # console file tty, is a must, wont boot without.
    vb.customize ['modifyvm', :id, '--uartmode1', 'file', "%s-console.log" % vb.name]
  end

  # configure hostnames to access from localmachine
  if Vagrant.has_plugin? 'vagrant-hostmanager'
    config.hostmanager.enabled = true
    config.hostmanager.manage_host = true
    config.hostmanager.aliases = [
      'suite.local',
    ]
  else
    fail_with_message "vagrant-hostmanager missing, please install the plugin with this command:\nvagrant plugin install vagrant-hostmanager"
  end

  config.vm.provision "shell", path: "vagrant.sh"
end