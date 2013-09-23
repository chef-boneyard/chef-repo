#
# Cookbook Name:: chef-cloudpassage
# Recipe:: default
#
# Combined between:
# Copyright 2012-2013, Escape Studios
# ...and:
# Copyright 2013, CloudPassage
#

# Form the group tag to associate this new node to in CloudPassage.
group_tag = "#{node[:node_group][:tag]}-#{node.chef_environment}"

bash "echo something" do
   code <<-EOF
     echo 'I am a chef! Env        #{node.chef_environment}'
     echo 'I am a chef! group desc #{node[:node_group][:description]}'
     echo 'I am a chef! group tag  #{node[:node_group][:tag]}'
     echo 'I am a chef! final group tag #{group_tag}'
   EOF
end

case node[:platform]
  when "debian", "ubuntu"
    base_url = "http://packages.cloudpassage.com/debian debian main"
    repo_cmd = "echo 'deb #{base_url}' | sudo tee /etc/apt/sources.list.d/cloudpassage.list > /dev/null"
    key_cmd = "curl http://packages.cloudpassage.com/cloudpassage.packages.key | sudo apt-key add -"
    check_key_installed = "sudo apt-key list | grep -i cloudpassage"
    update_repo_cmd = "sudo apt-get update"

  when "centos", "fedora", "rhel", "redhat", "amazon"
    base_url = "http://packages.cloudpassage.com/redhat/$basearch\ngpgcheck=1"
    repo_cmd = "echo -e '[cloudpassage]\nname=CloudPassage\nbaseurl=#{base_url}' | sudo tee /etc/yum.repos.d/cloudpassage.repo > /dev/null"
    key_cmd = "sudo rpm --import http://packages.cloudpassage.com/cloudpassage.packages.key"
    check_key_installed = "sudo rpm -qa gpg-pubkey* | xargs -i rpm -qi {} | grep -i cloudpassage"
    update_repo_cmd = "sudo yum list --assumeyes > /dev/null"
end

# add CloudPassage repository
execute "add-cloudpassage-repository" do
  command "#{repo_cmd}"
  action :run
  not_if check_key_installed
  notifies :run, "execute[import-cloudpassage-public-key]", :immediately
end

# import CloudPassage public key
execute "import-cloudpassage-public-key" do
  command "#{key_cmd}"
  action :nothing
  notifies :run, "execute[update-repositories]", :immediately
end

# update repositories
execute "update-repositories" do
  command "#{update_repo_cmd}"
  action :nothing
end

# install the daemon
package "cphalo" do
  action :upgrade
  notifies :restart, "service[cphalod]", :immediately
end

#start the daemon
service "cphalod" do
    start_command "sudo /etc/init.d/cphalod start --daemon-key=#{node[:cloudpassage][:license_key]} --tag=#{group_tag}"
    stop_command "service cphalod stop"
    status_command "service cphalod status"
    restart_command "service cphalod restart --daemon-key=#{node[:cloudpassage][:license_key]} --tag=#{group_tag}"
    supports [:start, :stop, :status, :restart]
    #starts the service if it's not running and enables it to start at system boot time
    action [:enable, :start]
end
