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
my_host = ''
my_ip = ''
unless Chef::Config[:solo]
  #TODO(jwood) Add Chef Server queries here.
else
  my_host = node[:solo_ips][:my_host]
  my_ip = node[:solo_ips][:my_ip]
  for host in node[:solo_ips][:cluster_hosts]
    hosts.push(host)
  end
  for ip in node[:solo_ips][:cluster_ips]
    ips.push(ip)
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
#   - Get the ip and hostname for this node
host_entry = "#{my_ip}\t#{my_host}\n"
es_hosts_entries = []

#   - Build my cluster host entries.
host_ips.each do |host, ip|
  es_hosts_entries.push("#{ip}\t#{host}\n")
end

#   - Write the hosts file with host entries.
template "/etc/hosts" do
  source "hosts.erb"
  variables(
    :host_entry => host_entry,
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
