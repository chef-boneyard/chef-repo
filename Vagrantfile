# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.box = "opscode-centos-6.4"
  config.vm.box_url = "https://opscode-vm-bento.s3.amazonaws.com/vagrant/opscode_centos-6.4_provisionerless.box"

  config.vm.define :graphite do |graphite|
    graphite.vm.hostname = "graphite"
    graphite.vm.provision :chef_solo do |chef|
      chef.roles_path = "roles"
      chef.run_list = [
        "role[base]",
        "recipe[graphite]",
        "recipe[chef-cloudpassage]"
      ]
    end
  end

  config.vm.define :statsd do |statsd|
    statsd.vm.hostname = "statsd"
    statsd.vm.provision :chef_solo do |chef|
      chef.roles_path = "roles"
      chef.run_list = [
        "role[base]",
        "recipe[chef-statsd]",
        "recipe[chef-cloudpassage]"
      ]
    end
  end

  config.berkshelf.enabled = true
  config.omnibus.chef_version = :latest

end
