#
# Cookbook Name:: datadog
# Recipe:: dd-agent
#
# Copyright 2011-2014, Datadog
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

# Install the Apt/Yum repository if enabled
include_recipe 'datadog::repository' if node['datadog']['installrepo']

dd_agent_version = node['datadog']['agent_version']

# If version specified and lower than 5.x
if !dd_agent_version.nil? && dd_agent_version.split('.')[0].to_i < 5
  # Select correct package name based on attribute
  dd_pkg_name = node['datadog']['install_base'] ? 'datadog-agent-base' : 'datadog-agent'

  package dd_pkg_name do
    version dd_agent_version
  end
else
  # default behavior, remove the `base` package as it is no longer needed
  package 'datadog-agent-base' do
    action :remove
  end
  # Install the regular package
  package 'datadog-agent' do
    version dd_agent_version
  end
end

# Set the correct Agent startup action
agent_action = node['datadog']['agent_start'] ? :start : :stop

# Make sure the config directory exists
directory '/etc/dd-agent' do
  owner 'root'
  group 'root'
  mode 0755
end

#
# Configures a basic agent
# To add integration-specific configurations, add 'datadog::config_name' to
# the node's run_list and set the relevant attributes
#
raise "Add a ['datadog']['api_key'] attribute to configure this node's Datadog Agent." if node['datadog'] && node['datadog']['api_key'].nil?

template '/etc/dd-agent/datadog.conf' do
  owner 'root'
  group 'root'
  mode 0644
  variables(
    :api_key => node['datadog']['api_key'],
    :dd_url => node['datadog']['url']
  )
end

# Common configuration
service 'datadog-agent' do
  action [:enable, agent_action]
  supports :restart => true, :status => true, :start => true, :stop => true
  subscribes :restart, 'template[/etc/dd-agent/datadog.conf]', :delayed unless node['datadog']['agent_start'] == false
end
