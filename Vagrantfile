
Vagrant.configure("2") do |config|
  config.vm.box = "opscode-centos-6.6"
  config.vm.box_url = "http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_centos-6.6_chef-provisionerless.box"
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
    chef.environment = "STAGING"
    chef.add_role "test_server"
    chef.custom_config_path = "Vagrantfile.chef"
    chef.delete_node = true
    chef.delete_client = true
  end
end 

