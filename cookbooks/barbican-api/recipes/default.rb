#
# Cookbook Name:: barbican-api
# Recipe:: default
#
# Note that the yum repository configuration used here was found at this site:
#   http://docs.opscode.com/resource_cookbook_file.html
#

include_recipe "barbican-base"

package 'barbican-common'

package 'barbican-api'

#TODO(jwood) Eventually get these values from a data bag.
host_name = "#{node[:barbican_api][:host_name]}"
db_name = "#{node[:barbican_api][:db_name]}"
db_user = "#{node[:barbican_api][:db_user]}"
db_pw = '"#{node[:barbican_api][:db_pw]}"
db_ip = ''
queue_ip = ''

# Determine external dependencies.
unless Chef::Config[:solo]
  # Add Chef Server queries here.
else
  db_ip = "#{node[:solo_ips][:db]}"
  queue_ip = "#{node[:solo_ips][:queue]}"
end

# Configure based on external dependencies.
template "/etc/barbican/barbican-api.conf" do
  source "barbican-api.conf.erb"
#  owner "root"
#  group "root"
  variables({
    :host_name => "#{host_name}",
    :db_user => "#{db_user}",
    :db_pw => "#{db_pw}",
    :db_ip => "#{db_ip}",
    :db_name => "#{db_name}",
    :queue_ip => "#{queue_ip}"
  })
end

# Start the daemon
service "barbican-api" do
  provider Chef::Provider::Service::Upstart
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end
#service "barbican-api" do
#    start_command "sudo /etc/init.d/barbican-api start"
#    stop_command "stop barbican-api"
#    status_command "status barbican-api"
#    restart_command "restart barbican-api"
#    supports [:start, :stop, :status, :restart]
#    #starts the service if it's not running and enables it to start at system boot time
#    action [:enable, :start]
#end

