Vagrant.configure("2") do |config|
  config.vm.box = "CentOS 6.3 32bit"
  config.vm.box_url = "http://tom.davidson.me.uk/dev/vagrant/centos63-32.box"
  config.omnibus.chef_version = :latest
  config.vm.provider "virtualbox" do |v|
    v.gui = true
  end
  config.vm.provision :chef_client do |chef|
    chef.provisioning_path = "/etc/chef"
    chef.chef_server_url = "https://api.opscode.com/organizations/papi"
    chef.validation_key_path = "~/chef-repo/.chef/papi-validator.pem"
    chef.validation_client_name = "papi-validator"
    chef.node_name = "server"
  end
end 

