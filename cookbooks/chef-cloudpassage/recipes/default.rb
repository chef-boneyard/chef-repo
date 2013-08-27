#
# Cookbook Name:: cloudpassage
# Recipe:: default
#
# Copyright 2012-2013, Escape Studios
#

case node[:platform]
    when "debian", "ubuntu"
        #add CloudPassage repository
        command_add_repo = "echo 'deb http://packages.cloudpassage.com/#{node[:cloudpassage][:repository_key]}/debian debian main' | sudo tee /etc/apt/sources.list.d/cloudpassage.list > /dev/null"

        #install curl
        package "curl" do
            action :install
        end

        #import CloudPassage public key
        command_import = "curl http://packages.cloudpassage.com/cloudpassage.packages.key | sudo apt-key add -"
        gpg_key_already_installed = "sudo apt-key list | grep cloudpassage"

        #update the local package list
        command_update_repos = "sudo apt-get update"
    when "redhat", "centos", "fedora", "scientific", "amazon"
        #add CloudPassage repository
        command_add_repo = "echo '[cloudpassage]\nname=CloudPassage production\nbaseurl=http://packages.cloudpassage.com/#{node[:cloudpassage][:repository_key]}/redhat/$basearch\ngpgcheck=1' | sudo tee /etc/yum.repos.d/cloudpassage.repo > /dev/null"

        #import CloudPassage public key
        command_import = "sudo rpm --import http://packages.cloudpassage.com/cloudpassage.packages.key"
        gpg_key_already_installed = "sudo rpm -qa gpg-pubkey* | xargs -i rpm -qi {} | grep cloudpassage"

        #update the local package list
        command_update_repos = "sudo yum update --assumeyes"
end

#add CloudPassage repository
execute "cloudpassage-repo" do
    command "#{command_add_repo}"
    action :run
    not_if gpg_key_already_installed
    notifies :run, "execute[cloudpassage-import-public-key]", :immediately
end

#import CloudPassage public key
execute "cloudpassage-import-public-key" do
    command "#{command_import}" 
    action :nothing
    notifies :run, "execute[cloudpassage-apt-get-update]", :immediately
end

#update the local package list
execute "cloudpassage-apt-get-update" do
    command "#{command_update_repos}" 
    action :nothing
end

#install/upgrade the daemon
package "cphalo" do
    action :upgrade
    notifies :restart, "service[cphalod]", :immediately
end

#start the daemon
service "cphalod" do
    start_command "sudo /etc/init.d/cphalod start --daemon-key=#{node[:cloudpassage][:license_key]}"
    stop_command "service cphalod stop"
    status_command "service cphalod status"
    restart_command "service cphalod restart --daemon-key=#{node[:cloudpassage][:license_key]}"
    supports [:start, :stop, :status, :restart]
    #starts the service if it's not running and enables it to start at system boot time
    action [:enable, :start]
end

