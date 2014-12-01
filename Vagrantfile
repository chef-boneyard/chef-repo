
Vagrant.configure("2") do |config|
<<<<<<< HEAD
  #config.berkshelf.enabled = true
  #config.berkshelf.berksfile_path = "Berksfile"
  config.vm.box = "opscode-centos-6.6"
  config.vm.box_url = "http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_centos-6.6_chef-provisionerless.box"
  #  config.vm.box_url = "http://tom.davidson.me.uk/dev/vagrant/centos63-32.box"
  #  config.vm.box = "centos63"
=======
#  config.berkshelf.enabled = true
#  config.berkshelf.berksfile_path = "cookbooks/my_cookbook/Berksfile"
  config.vm.box = "centos63"
  config.vm.box_url = "http://tom.davidson.me.uk/dev/vagrant/centos63-32.box"
>>>>>>> 8d6efdbaca5ee23592d554b4ffb635d14200ca9a
  config.omnibus.chef_version = :latest
  config.vm.provider "virtualbox" do |v|
    v.gui = true
  end
  config.vm.provision :chef_client do |chef|
    chef.chef_server_url = "https://api.opscode.com/organizations/papi"
    chef.provisioning_path = "/etc/chef"
    chef.validation_key_path = "/var/chef-repo/.chef/papi-validator.pem"
    chef.validation_client_name = "papi-validator"
    chef.node_name = "my_server"
<<<<<<< HEAD

=======
    # Add a recipe
    chef.add_recipe "my_cookbook"
    # Or maybe a role
    chef.add_role "web_servers"
>>>>>>> 8d6efdbaca5ee23592d554b4ffb635d14200ca9a
  end
end 

