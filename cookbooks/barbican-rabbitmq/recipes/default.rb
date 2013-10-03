#
# Cookbook Name:: barbican-rabbitmq
# Recipe:: default
#
# Copyright (C) 2013 Rackspace, Inc.
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#    http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Note that the yum repository configuration used here was found at this site:
#   http://docs.opscode.com/resource_cookbook_file.html
#

# Do anything needed beyond the standard rabbit mq install here

include_recipe "barbican-base"

# Build a map of host name to IP addresses, for queue nodes in my cluster.
hosts = []
ips = []
env = 'unknown'
if Chef::Config[:solo]
  for host_entry in node[:solo_ips]
    hosts.push(host_entry[:hostname])
    ips.push(host_entry[:ip])    
  end
  env = 'solo'
else
  q_nodes = search(:node, "role:barbican-queue AND chef_environment:#{node.chef_environment}")
  if q_nodes.empty?
    Chef::Log.info 'No other queue nodes found to cluster with.'
  else
    for q_node in q_nodes
      hosts.push(q_node[:hostname])
      ips.push(q_node[:ipaddress])          
    end
  end
  env = node.chef_environment
end
host_ips = Hash[hosts.zip(ips)] 
Chef::Log.debug "Final host-ip hash: #{host_ips}"
Chef::Log.debug "rabbitmq cluster: #{node['rabbitmq']['cluster']}"
Chef::Log.debug "rabbitmq clusters: #{node['rabbitmq']['cluster_disk_nodes']}"

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
#    - Set the erlang cookie, that must be the same across all cluster nodes.
node.set['rabbitmq']['erlang_cookie'] = "#{node[:node_group][:tag]}-#{env}"
unless Chef::Config[:solo]
  node.save
end
Chef::Log.debug "rabbitmq cookie: #{node['rabbitmq']['erlang_cookie']}"

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
