#
# Cookbook Name:: barbican-api
# Recipe:: default
#
# Note that the yum repository configuration used here was found at this site:
#   http://docs.opscode.com/resource_cookbook_file.html
#

include_recipe "barbican-base"

%w{ barbican-common barbican-api }.each do |pkg|
  package pkg
end

#TODO(jwood) Eventually get these values from a data bag.
host_name = "#{node[:barbican_api][:host_name]}"
db_name = "#{node[:barbican_api][:db_name]}"
db_user = "#{node[:barbican_api][:db_user]}"
db_pw = "#{node[:barbican_api][:db_pw]}"
connection = ''
db_ip = ''
q_ips = []

# Determine external dependencies.
if Chef::Config[:solo]
  db_ip = "#{node[:solo_ips][:db]}"
  for host_entry in node[:solo_ips][:queue_ips]
    q_ips.push(host_entry[:ip])    
  end
else
  # Get the DB node.
  db_nodes = search(:node, "role:barbican-db AND chef_environment:#{node.chef_environment}")
  if db_nodes.empty?
    Chef::Log.info 'No database nodes found, using sqlite backend instead.'
    connection = 'sqlite:////var/lib/baribcan/barbican.sqlite'
  else
    db_node = db_nodes[0]
    db_ip = db_node[:ipaddress]
    db_pw = db_node[:postgresql][:password][:postgres]
  end

  # Get the cluster of queue nodes.
  q_nodes = search(:node, "role:barbican-queue AND chef_environment:#{node.chef_environment}")
  if q_nodes.empty?
    Chef::Log.info 'No other queue nodes found to cluster with.'
  else
    for q_node in q_nodes
      q_ips.push(q_node[:ipaddress])          
    end
  end
end
if connection.empty?
  connection = "postgresql+psycopg2://#{db_user}:#{db_pw}@#{db_ip}:5432/#{db_name}"
end
queue_ips = q_ips.map{|n| "amqp://guest@#{n}/"}.join(',')
Chef::Log.debug "queue_ips: #{queue_ips}"

# Configure based on external dependencies.
%w{ barbican-api barbican-admin }.each do |barbican_conf|
  template "/etc/barbican/#{barbican_conf}.conf" do
    source "#{barbican_conf}.conf.erb"
    owner "barbican"
    group "barbican"
    variables({
      :host_name => host_name,
      :connection => connection,
      :queue_ips => queue_ips
    })
  end
end

# Start the daemon
service "barbican-api" do
  provider Chef::Provider::Service::Upstart
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end

