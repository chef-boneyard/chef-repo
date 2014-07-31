#
# Cookbook Name:: torque
# Authors:: Sandor Acs <acs.sandor@mta.sztaki.hu>, Mark Gergely <gergely.mark@mta.sztaki.hu>
#
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

# Install torque mom service
package 'torque-mom' do
    action :install
end

case node['platform_family']
when 'debian'
  service_mom = 'torque-mom'
when 'rhel'
  service_mom = 'pbs_mom'
end

# Set up the hostname of the torque server
hnodes = search(:node, "recipes:torque\\:\\:head_node AND chef_environment:#{node.environment}")

template "#{node['torque']['etc_dir']}/server_name" do
  source 'server_name.erb'
  owner 'root'
  group 'root'
  mode '644'
  variables(
    :hnodes => hnodes
  )
  notifies :restart, "service[#{service_mom}]", :immediately
end

if platform_family?('rhel')
  template "#{node['torque']['etc_dir']}/mom/config" do
  source 'mom_config.erb'
  owner 'root'
  group 'root'
  mode '644'
  variables(
    :hnodes => hnodes
  )
  notifies :restart, "service[#{service_mom}]", :immediately
  end
end

# Set up authorized_key
file "/home/#{node.torque.user}/.ssh/authorized_keys" do
  content "#{hnodes[0].torque.publickey}"
  owner "#{node.torque.user}"
  group "#{node.torque.user}"
  mode 00644
  notifies :restart, "service[#{service_mom}]", :immediately
end

# Set up torque mom service
service "#{service_mom}" do
  pattern 'pbs_mom'  
  action [:start, :enable]
  supports :start => true, :stop => true, :restart => true
end
