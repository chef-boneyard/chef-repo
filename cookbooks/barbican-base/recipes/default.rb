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

execute "install-epel" do
 command "rpm -Uvh http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm"
 action :run
 not_if "rpm -qa | grep -qx 'epel-release-6-8.noarch'"
end

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

cookbook_file "/etc/yum.repos.d/barbican.repo" do
  source "barbican.repo"
  mode 00644
  notifies :run, "execute[create-yum-cache]", :immediately
  notifies :create, "ruby_block[reload-internal-yum-cache]", :immediately
end

