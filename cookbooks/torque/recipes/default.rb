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

# Install torque common
case node['platform_family']
when 'debian'
  pkg = 'torque-common'
when 'rhel'
  include_recipe 'yum-epel::default'
  pkg = 'torque'
end

package pkg do
  action :install
end

# Set up user
user "#{node.torque.user}" do
  action :create
  home "/home/#{node.torque.user}"
  shell '/bin/bash'
end

# Workaround for buggy chef user
directory "/home/#{node.torque.user}" do
  owner "#{node.torque.user}"
  group "#{node.torque.user}"
  mode 00755
  action :create
  only_if { platform_family?('debian') }
end

# Set up SSH directory and config file
directory "/home/#{node.torque.user}/.ssh" do
  owner "#{node.torque.user}"
  group "#{node.torque.user}"
  mode 00700
  action :create
end

cookbook_file "/home/#{node.torque.user}/.ssh/config" do
  source 'config'
  owner "#{node.torque.user}"
  group "#{node.torque.user}"
  action :create
end
