#
# Cookbook Name:: barbican-base
# Recipe:: default
#
# Note that the yum repository configuration used here was found at this site:
#   http://docs.opscode.com/resource_cookbook_file.html
#

#
# Load firewall rules we know works
#
#template "/etc/sysconfig/iptables" do
#  # path "/etc/sysconfig/iptables"
#  source "iptables.erb"
#  owner "root"
#  group "root"
#  mode 00600
#  # notifies :restart, resources(:service => "iptables")
#end

#execute "service iptables restart" do
#  user "root"
#  command "service iptables restart"
#end

include_recipe 'yum::epel'

execute "create-yum-cache" do
 command "yum -q makecache"
 action :nothing
end

ruby_block "reload-internal-yum-cache" do
  block do
    Chef::Provider::Package::Yum::YumCache.instance.reload
  end
  action :nothing
end

#TODO(dmend): Use yum_repository resource instead of cookbook_file
cookbook_file "/etc/yum.repos.d/barbican.repo" do
  source "barbican.repo"
  mode 00644
  notifies :run, "execute[create-yum-cache]", :immediately
  notifies :create, "ruby_block[reload-internal-yum-cache]", :immediately
end

# Configure NewRelic on this server.
unless Chef::Config[:solo]
  newrelic_info = data_bag_item(node.chef_environment, 'newrelic')
  node.set['newrelic'] = node['newrelic'].merge(newrelic_info)
  node.save
  include_recipe 'barbican-base::newrelic'
end

#TODO(jwood) Find a final home this eventually.
#unless Chef::Config[:solo]
#  newrelic_info = data_bag_item(node.chef_environment, 'newrelic')
#  Chef::Log.debug "newrelic license: #{newrelic_info['server_monitoring']['license']}"
#  node.set['newrelic'] = node['newrelic'].merge(newrelic_info)
#  node.save
#  include_recipe 'newrelic::repository'
#  include_recipe 'newrelic::server-monitor'
#end
