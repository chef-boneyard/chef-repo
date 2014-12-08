#
# Cookbook Name:: datadog
# Attributes:: default
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

# Place your API Key here, or set it on the role/environment/node
# The Datadog api key to associate your agent's data with your organization.
# Can be found here:
# https://app.datadoghq.com/account/settings
default['datadog']['api_key'] = nil

# Create an application key on the Account Settings page
default['datadog']['application_key'] = nil

# Don't change these
# The host of the Datadog intake server to send agent data to
default['datadog']['url'] = 'https://app.datadoghq.com'

# Add tags as override attributes in your role
default['datadog']['tags'] = ''

# Autorestart agent
default['datadog']['autorestart'] = false

# Repository configuration
architecture_map = {
  'i686' => 'i386',
  'i386' => 'i386',
  'x86' => 'i386'
}
architecture_map.default = 'x86_64'

default['datadog']['installrepo'] = true
default['datadog']['aptrepo'] = 'http://apt.datadoghq.com'
default['datadog']['aptrepo_dist'] = 'stable'
default['datadog']['yumrepo'] = "http://yum.datadoghq.com/rpm/#{architecture_map[node['kernel']['machine']]}/"

# Set to true to always install datadog-agent-base (usually only installed on
# systems with a version of Python lower than 2.6) instead of datadog-agent
#
# The .gsub is done because some platforms may append characters that aren't valid for a Gem::Version comparison.
begin
  default['datadog']['install_base'] = Gem::Version.new(node['languages']['python']['version'].gsub(/(\d\.\d\.\d).+/, '\\1')) < Gem::Version.new('2.6.0')
rescue NoMethodError # nodes['languages']['python'] == nil
  Chef::Log.warn 'no version of python found, please install Agent version 5.x or higher.'
rescue ArgumentError
  Chef::Log.warn "could not parse python version string: #{node['languages']['python']['version']}"
end

# Agent Version
default['datadog']['agent_version'] = nil

# Chef handler version
default['datadog']['chef_handler_version'] = nil

# Enable the Chef handler to report to datadog
default['datadog']['chef_handler_enable'] = true

# Boolean to enable debug_mode, which outputs massive amounts of log messages
# to the /tmp/ directory.
default['datadog']['debug'] = false

# Default to false to non_local_traffic
# See: https://github.com/DataDog/dd-agent/wiki/Network-Traffic-and-Proxy-Configuration
default['datadog']['non_local_traffic'] = false

# How often you want the agent to collect data, in seconds. Any value between
# 15 and 60 is a reasonable interval.
default['datadog']['check_freq'] = 15

# Specify agent hostname
# More information available here: http://docs.datadoghq.com/hostnames/#agent
default['datadog']['hostname'] = node.name

# If running on ec2, if true, use the instance-id as the host identifier
# rather than the hostname for the agent or nodename for chef-handler.
default['datadog']['use_ec2_instance_id'] = false

# Use mount points instead of volumes to track disk and fs metrics
default['datadog']['use_mount'] = false

# Change port the agent is listening to
default['datadog']['agent_port'] = 17123

# Start agent or not
default['datadog']['agent_start'] = true

# Start a graphite listener on this port
# https://github.com/DataDog/dd-agent/wiki/Feeding-Datadog-with-Graphite
default['datadog']['graphite'] = false
default['datadog']['graphite_port'] = 17124

# log-parsing configuration
default['datadog']['dogstreams'] = []

# Logging configuration
default['datadog']['syslog']['active'] = false
default['datadog']['syslog']['udp'] = false
default['datadog']['syslog']['host'] = nil
default['datadog']['syslog']['port'] = nil

# Web proxy configuration
default['datadog']['web_proxy']['host'] = nil
default['datadog']['web_proxy']['port'] = nil
default['datadog']['web_proxy']['user'] = nil
default['datadog']['web_proxy']['password'] = nil

# dogstatsd
default['datadog']['dogstatsd'] = true
default['datadog']['dogstatsd_port'] = 8125
default['datadog']['dogstatsd_interval'] = 10
default['datadog']['dogstatsd_normalize'] = 'yes'

# For service-specific configuration, use the integration recipes included
# in this cookbook, and apply them to the appropirate node's run list.
# Read more at http://docs.datadoghq.com/

# For older integrations that do not consume the conf.d yaml files
default['datadog']['legacy_integrations']['nagios']['enabled'] = false
default['datadog']['legacy_integrations']['nagios']['description'] = 'Nagios integration'
default['datadog']['legacy_integrations']['nagios']['config']['nagios_log'] = '/var/log/nagios3/nagios.log'
