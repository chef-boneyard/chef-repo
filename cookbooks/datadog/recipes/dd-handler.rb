#
# Cookbook Name:: datadog
# Recipe:: dd-handler
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

include_recipe 'chef_handler'
ENV['DATADOG_HOST'] = node['datadog']['url']

chef_gem 'chef-handler-datadog' do
  action :install
  version node['datadog']['chef_handler_version']
end
require 'chef/handler/datadog'

# Create the handler to run at the end of the Chef execution
chef_handler 'Chef::Handler::Datadog' do
  source 'chef/handler/datadog'
  arguments [
    :api_key => node['datadog']['api_key'],
    :application_key => node['datadog']['application_key'],
    :use_ec2_instance_id => node['datadog']['use_ec2_instance_id']
  ]
  supports :report => true, :exception => true
  action :nothing
end.run_action(:enable) if node['datadog']['chef_handler_enable']
