# -*- mode: ruby -*-
# vi: set ft=ruby :

# Specify minimum Vagrant version and Vagrant API version
Vagrant.require_version '>= 1.6.0'
VAGRANTFILE_API_VERSION = '2'

# Require 'yaml' module
require 'yaml'

# Read YAML file with VM details (box, CPU, RAM, IP addresses)
# Be sure to edit machines.yml to provide correct IP addresses
machines = YAML.load_file(File.join(File.dirname(__FILE__), 'machines.yml'))

# Create and configure the VMs
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # Always use Vagrant's default insecure key
  config.ssh.insert_key = false

  # Iterate through entries in YAML file to create VMs
  machines.each do |machine|

    # Configure the VMs per details in machines.yml
    config.vm.define machine['name'] do |srv|
      srv.vm.network "forwarded_port", guest: 8080, host: 8090, host_ip: "127.0.0.1"

      # Don't check for box updates
      srv.vm.box_check_update = false

      # Specify hostname and Vagrant box
      srv.vm.hostname = machine['name']

      # Specify the Vagrant box to use (use VMware box by default)
      srv.vm.box = machine['box']['vmw']

      # Configure default synced folder (disable by default)
      if machine['sync_disabled'] != nil
        srv.vm.synced_folder '.', '/shared', disabled: machine['sync_disabled']
      else
        srv.vm.synced_folder '.', '/shared', disabled: true
      end #if machine['sync_disabled']

      # Iterate through networks as per settings in machines.yml
      machine['nics'].each do |net|
        if net['ip_addr'] == 'dhcp'
          srv.vm.network net['type'], type: net['ip_addr']
        else
          srv.vm.network net['type'], ip: net['ip_addr']
        end # if net['ip_addr']
      end # machine['nics'].each

      # Configure VMs with RAM and CPUs per settings in machines.yml (Fusion)
      srv.vm.provider 'vmware_fusion' do |vmw|
        vmw.vmx['memsize'] = machine['ram']
        vmw.vmx['numvcpus'] = machine['vcpu']
        if machine['nested'] == true
          vmw.vmx['vhv.enable'] = 'TRUE'
        end #if machine['nested']
      end # srv.vm.provider 'vmware_fusion'

      # Configure VMs with RAM and CPUs per settings in machines.yml (VirtualBox)
      srv.vm.provider 'virtualbox' do |vb, override|
        vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
        vb.memory = machine['ram']
        vb.cpus = machine['vcpu']
        override.vm.box = machine['box']['vb']
      end # srv.vm.provider 'virtualbox'

      # Configure CPU & RAM per settings in machines.yml (Libvirt)
      srv.vm.provider 'libvirt' do |lv,override|
        lv.memory = machine['ram']
        lv.cpus = machine['vcpu']
        override.vm.box = machine['box']['lv']
        if machine['nested'] == true
          lv.nested = true
        end # if machine['nested']
      end # srv.vm.provider 'libvirt'

      # Provision shell or file
      machine['provision'].each do |prv|
        if prv['type'] == 'shell'
          if prv['run'] == 'allways'
            srv.vm.provision 'shell', path: prv['path'], run: 'allways'
          else
            srv.vm.provision 'shell', path: prv['path']
          end # if prv['run']
        end # if prv['type']
        if prv['type'] == 'file'
          srv.vm.provision 'file', source: prv['source'], destination: prv['destination']
        end # if prv['type']
      end # machine['provision'].each
    end # config.vm.define
  end # machines.each
end # Vagrant.configure
