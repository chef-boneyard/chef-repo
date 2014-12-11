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
#include_recipe "ntp-cookbook"
include_recipe "chef_handler"
include_recipe "my_cookbook::my_flowdock"
include_recipe "my_cookbook::my_ipaddress"
include_recipe "chef-slack_handler"



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



execute 'print recipe name $msg ' do
  environment 'msg' => "RECIPE [#{recipe_name}]"
  command 'echo $msg > /tmp/recipe_name.txt'
end

node.override['my_cookbook']['developer'] = 'someone else '


execute 'echo the developer name' do
  command "echo #{node['my_cookbook']['developer']}"
end

logservers = search(:node, "role:log" )

logservers.each do |srv|
  log srv.name
end


template "/tmp/list_of_logservers" do
  source "list_of_logservers.erb"
  variables(
    :logservers => logservers
  )
end


#hook = data_bag_item('hooks', 'request_bin')
#http_request 'callback' do
#  url hook['url']
#end

#same as above, but more elaborate
search(:hooks, '*:*').each do |hook|
  http_request 'callback' do
    url hook['url']
  end
end

google_account = Chef::EncryptedDataBagItem.load("accounts", "google")


#TEST:

Chef::Log.info ("TEST --->   encrypted password is:#{google_account["password"]}    <---TEST")


file "/tmp/backup_config.json" do
  owner "root"
  group "root"
  mode 0644
  content data_bag_item('servers', 'backup')['host'].to_json
end


Chef::Log.info ("#{message}")

