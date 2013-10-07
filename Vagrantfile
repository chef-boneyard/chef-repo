Vagrant.configure("2") do |config|
#  config.berkshelf.enabled = true
#  config.berkshelf.berksfile_path = "cookbooks/my_cookbook/Berksfile"
  config.vm.box = "centos63"
  config.vm.box_url = "http://tom.davidson.me.uk/dev/vagrant/centos63-32.box"
  config.omnibus.chef_version = :latest
  config.vm.provider "virtualbox" do |v|
    v.gui = true
  end
  config.vm.provision :chef_client do |chef|
    chef.chef_server_url = "https://api.opscode.com/organizations/papi"
    chef.validation_key_path = "/home/mlev/chef-repo/.chef/papi-validator.pem"
    chef.validation_client_name = "papi-validator"
    chef.node_name = "my_server"
    # Add a recipe
    chef.add_recipe "my_cookbook"
    # Or maybe a role
    chef.add_role "web_servers"
  end
end 

