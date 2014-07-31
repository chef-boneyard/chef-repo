#
# Cookbook Name:: torque
# Authors:: Sandor Acs <acs.sandor@mta.sztaki.hu>, Mark Gergely <gergely.mark@mta.sztaki.hu>
# Copyright 2014, MTA SZTAKI
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe 'torque::default'

# Install torque server and client packages
%w(
  torque-server
  torque-scheduler
  torque-client
  ).each do |pkg|
    package pkg do
    action :install
  end
end

# Set up server name 
execute 'fix_server_name' do
  command "echo '#{node.fqdn}' > '#{node.torque.etc_dir}/server_name'"
  not_if "grep '#{node.fqdn}' '#{node.torque.etc_dir}/server_name'"
end

# Workaround nodes file
execute 'fix_nodes_path' do
  command "ln -s #{node['torque']['var_dir']}/nodes #{node['torque']['var_dir']}/server_priv/nodes"
  not_if { File.exist?("#{node['torque']['var_dir']}/server_priv/nodes") }
end

# Munge setup for rhel familí
if platform_family?('rhel')
  execute 'create-munge-key' do
    command 'create-munge-key'
    not_if { File.exist?('/etc/munge/munge.key') }
  end  
end

# Define torque server and scheduler services
case node['platform_family']
when 'debian'
  service_pbs_server = 'torque-server'
  service_pbs_sched = 'torque-scheduler'
when 'rhel'
  service_pbs_server = 'pbs_server'
  service_pbs_sched = 'pbs_sched'
  service 'munge' do
    action [:start, :enable]
    supports :start => true, :stop => true, :restart => true
  end
end

# Set up the compute nodes

cnodes = search(:node, "recipes:torque\\:\\:compute_node AND chef_environment:#{node.environment}" )
template "#{node['torque']['var_dir']}/nodes" do
  source 'compute_nodes.erb'
  owner 'root'
  group 'root'
  mode 0644
  variables(
    :cnodes => cnodes
  )
  notifies :restart, "service[#{service_pbs_server}]", :immediately
  notifies :restart, "service[#{service_pbs_sched}]", :immediately
  if platform_family?('rhel')
    notifies :restart, 'service[munge]', :immediately
  end
end

# Set up the compute nodes
template '/tmp/queue_config' do
  source 'queue_config.erb'
  owner 'root'
  group 'root'
  mode 0744
  notifies :run, 'execute[default_queue_setup]', :delayed
end

# Initialize the queue
execute 'default_queue_setup' do
  action :nothing
  command '/tmp/queue_config' 
  notifies :restart, "service[#{service_pbs_server}]", :immediately
  notifies :restart, "service[#{service_pbs_sched}]", :immediately
  if platform_family?('rhel')
    notifies :restart, 'service[munge]', :immediately
  end
end

# Generating ssh key pair and fix permissions
execute 'generate_ssh_keys' do
    user "#{node.torque.user}"
    group "#{node.torque.user}"
    creates "/home/#{node.torque.user}/.ssh/id_rsa.pub"
    command "ssh-keygen -t rsa -q -f /home/#{node.torque.user}/.ssh/id_rsa -P \"\""
end

# Update public key
ruby_block 'update_pubkey' do
  block do
    if File.exists?("/home/#{node.torque.user}/.ssh/id_rsa.pub")
      a = File.open("/home/#{node.torque.user}/.ssh/id_rsa.pub","rb") {|io| io.read}
      node.override['torque']['publickey'] = a
    end
  end
end

service "#{service_pbs_server}" do
  pattern 'pbs_server'  
  action [:start, :enable]
  supports :start => true, :stop => true, :restart => true
end

service "#{service_pbs_sched}" do
  pattern 'pbs_sched'
  action [:start, :enable]
  supports :start => true, :stop => true, :restart => true
end
