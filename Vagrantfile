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
    barbican_api.vm.provision :chef_solo do |chef|
      chef.roles_path = "roles"
      chef.run_list = [
        "role[base]",
        "recipe[barbican-api]"
      ]
    end
  end

  config.berkshelf.enabled = true
  config.omnibus.chef_version = :latest

end
