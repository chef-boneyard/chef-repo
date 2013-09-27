#
# Cookbook Name:: barbican-queue
# Recipe:: default
#
# Note that the yum repository configuration used here was found at this site:
#   http://docs.opscode.com/resource_cookbook_file.html
#

# Do anything needed beyond the standard rabbit mq install here

include_recipe "barbican-base"
#include_recipe "hostsfile"

# Build a map of host name to IP addresses, for queue nodes in my cluster.
host_ips = Hash.new()
hosts = []
ips = []
unless Chef::Config[:solo]
  #TODO(jwood) Add Chef Server queries here.
else
  for host_entry in node[:solo_ips]
    hosts.push(host_entry[:hostname])
    ips.push(host_entry[:ip])    
  end
  host_ips = Hash[hosts.zip(ips)] 
  Chef::Log.debug "host-ip hash: #{host_ips}"
end

Chef::Log.debug "rabbitmq cluster: #{node['rabbitmq']['cluster']}"
Chef::Log.debug "rabbitmq clusters: #{node['rabbitmq']['cluster_disk_nodes']}"


# Configure host table as needed by RabbitMQ clustering.
#host_ips.each do |host, ip|
#  hostsfile_entry "#{ip}" do
#    hostname "#{host}"
#    action :create_if_missing
#  end
#end

# Configure host table as needed by RabbitMQ clustering:
es_hosts_entries = []

#   - Build my cluster host entries.
host_ips.each do |host, ip|
  es_hosts_entries.push("#{ip}\t#{host}\n")
end

#   - Write the hosts file with host entries.
template "/etc/hosts" do
  source "hosts.erb"
  variables(
    :es_ips_hostnames => es_hosts_entries
  )
end


# Configure RabbitMQ:
#    - Default to true for clustered rabbit.
node.set["rabbitmq"]["cluster"] = true
#    - Create string of cluster nodes.
node.set['rabbitmq']['cluster_disk_nodes'] = hosts.map{|n| "rabbit@#{n}"}
Chef::Log.debug "rabbitmq cluster string: #{node['rabbitmq']['cluster_disk_nodes']}"

include_recipe "rabbitmq"

rabbitmq_user "guest" do
  password "guest"
  action :add
end

rabbitmq_policy "ha-all" do
  pattern "^(?!amq\\.).*"
  params "ha-mode" => "all"
  priority 1
  action :set
end

include_recipe "rabbitmq::mgmt_console"
