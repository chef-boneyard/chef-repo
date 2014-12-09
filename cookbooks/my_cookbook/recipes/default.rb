#
# Cookbook Name:: my_cookbook
# Recipe:: default
#
# Copyright 2013, Papi Company
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
message = "       **  ROLE        [#{node['my_cookbook']['role']}] install from my_cookbook  **      "

Chef::Log.info ("#{message}")
#include_recipe "ntp-cookbook"
include_recipe "chef_handler"
include_recipe "my_cookbook::my_flowdock"
include_recipe "my_cookbook::my_ipaddress"




template '/tmp/message' do
  source 'message.erb'
  variables(
    greet: 'Hallo',
    who: 'me',
    from: node['fqdn']
   )
end

template '/tmp/fqdn' do
  source 'fqdn.erb'
  variables(
  fqdn: node['fqdn']
  )
end

capistrano_deploy_dirs do
  deploy_to "/srv"
end


my_cookbook "Ohai" do
  title "Chef"

end



Chef::Log.info ("#{message}")

