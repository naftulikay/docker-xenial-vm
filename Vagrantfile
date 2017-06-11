#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'shellwords'

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.hostname = "devel"

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  config.vm.network "private_network", type: "dhcp"

  # Tweak the VMs configuration.
  config.vm.provider "virtualbox" do |vb|
    vb.memory = 1024
    vb.linked_clone = true
  end

  # Configure the VM using Ansible
  config.vm.provision "ansible_local" do |ansible|
    # allow passing ansible args from environment variable
    ansible.raw_arguments = Shellwords::shellwords(ENV.fetch("ANSIBLE_ARGS", ""))

    ansible.provisioning_path = "/vagrant/"
    ansible.playbook = "vagrant.yml"
    ansible.galaxy_role_file = "requirements.yml"
    ansible.galaxy_roles_path = "roles/"
  end

  # default machine is xenial, other is centos 7 for selinux testing
  config.vm.define "xenial", primary: true, autostart: true do |xenial|
    xenial.vm.box = "ubuntu/xenial"
    xenial.vm.box_url = "https://cloud-images.ubuntu.com/xenial/current/xenial-server-cloudimg-amd64-vagrant.box"
  end

  config.vm.define "centos7", autostart: false do |centos7|
    centos7.vm.box = "bento/centos-7.3"
  end
end
