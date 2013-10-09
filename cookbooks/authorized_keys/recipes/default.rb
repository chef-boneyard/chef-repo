#
# Cookbook Name:: authorized_keys
# Recipe:: default
#
# Copyright 2013, Rackspace
#
# All rights reserved - Do Not Redistribute
#

#install ruby json support 
chef_gem "json" do
  action :install
end

require 'rubygems'
require 'base64'
require 'json'
require 'net/https'

# Locate configuration items.
if Chef::Config[:solo]
  raise "No support for installing git keys onto Chef Solo VM instances."
end
auth_dir = "/root/.ssh"
ssh_auth_file = "authorized_keys"
ssh_auth_file_full = "#{auth_dir}/#{ssh_auth_file}"

github = data_bag_item(node[:authorized_keys][:databag_name], node[:authorized_keys][:databag_item])
repo_owner = github["repo_owner"]
repo_name = github["repo_name"]
token = github["token"]
github_uri = "https://api.github.com/repos/#{repo_owner}/#{repo_name}/contents/authorized_keys?access_token=#{token}"
url = URI(github_uri)

request = Net::HTTP::Get.new(url.request_uri,{"Accepts"=>"application/json"})
http = Net::HTTP.new(url.host, url.port)
http.use_ssl = true
resp = http.start {|http| http.request(request) }
Chef::Log.info("\nGitHub API response_code #{resp.code}\n")

if resp.code == "200"
  body = JSON.parse(resp.body)
  encoded_content = body['content']
  authorized_keys = Base64.decode64(encoded_content)
else
  raise "***Bad response code from GitHub API***"
end

directory auth_dir do
  recursive true
end

template "#{ssh_auth_file_full}" do
  source "authorized_keys.erb"
  variables(
    :authorized_keys => authorized_keys
  )
end
