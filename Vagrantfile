# -*- mode: ruby -*-
# vi: set ft=ruby :
#
# Use this Vagrantfile to standup the Baribican network
#

Vagrant.configure("2") do |config|

  config.vm.box = "opscode-centos-6.4"
  config.vm.box_url = "https://opscode-vm-bento.s3.amazonaws.com/vagrant/opscode_centos-6.4_provisionerless.box"

  config.vm.define :barbican_api do |barbican_api|
    barbican_api.vm.hostname = "barbican-api-test"

    # Forward guest port 9311 to host port 9311. If changed, run 'vagrant reload'.
    barbican_api.vm.network :forwarded_port, guest: 9311, host: 9311
    barbican_api.vm.network :forwarded_port, guest: 9312, host: 9312
    
    # Provision the node.
    barbican_api.vm.provision :chef_solo do |chef|
      chef.roles_path = "roles"
      chef.run_list = [
        "role[base]",
        "role[api]",
        "recipe[barbican-api]",
      ]
    end
  end

  config.berkshelf.enabled = true
  config.omnibus.chef_version = :latest

end
