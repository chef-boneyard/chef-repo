#
# Cookbook Name:: my_cookbook
# Recipe:: default
#
# Copyright 2013, Papi Company
#
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


message = "       **  ROLE        [#{node['my_cookbook']['role']}] writtern by [#{node['my_cookbook']['developer']}] install from my_cookbook  PLATFORM [#{node['platform']}]**      "

Chef::Log.info ("#{message}")
include_recipe "chef_handler"
include_recipe "chef-slack_handler"



include_recipe "my_cookbook::my_flowdock"
include_recipe "my_cookbook::my_ipaddress"
include_recipe "my_cookbook::resources_and_providers"
include_recipe "my_cookbook::search_roles"
include_recipe "my_cookbook::templates"
include_recipe "my_cookbook::data_bags"
include_recipe "my_cookbook::definitions"
#Sample environment and execute
execute 'print recipe name $msg ' do
  environment 'msg' => "RECIPE [#{recipe_name}]"
  command 'echo $msg > /tmp/recipe_name.txt'
end


#override example
node.override['my_cookbook']['developer'] = 'someone else '


execute 'echo the developer name' do
  command "echo #{node['my_cookbook']['developer']}"
end

Chef::Log.info ("#{message}")

