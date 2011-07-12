#
# Cookbook Name:: elasticsearch
# Recipe:: default
#
# Copyright 2010, GoTime
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

include_recipe "java"

package "unzip" do
  action :install
end

remote_file "/tmp/elasticsearch-#{node[:elasticsearch][:version]}.zip" do
  source "http://github.com/downloads/elasticsearch/elasticsearch/elasticsearch-#{node[:elasticsearch][:version]}.zip"
  mode "0644"
  checksum node[:elasticsearch][:checksum]
end

user "elasticsearch" do
  uid 61021
  gid "nogroup"
end

["/usr/lib/elasticsearch-#{node[:elasticsearch][:version]}", "/etc/elasticsearch"].each do |dir|
  directory dir do
    owner "root"
    group "root"
    mode 0755
  end
end

["/var/log/elasticsearch", "/var/lib/elasticsearch", "/var/run/elasticsearch"].each do |dir|
  directory dir do
    owner "elasticsearch"
    group "nogroup"
    mode 0755
  end
end

bash "unzip elasticsearch" do
  user "root"
  cwd "/tmp"
  code %(unzip /tmp/elasticsearch-#{node[:elasticsearch][:version]}.zip)
  not_if { File.exists? "/tmp/elasticsearch-#{node[:elasticsearch][:version]}" }
end

bash "copy elasticsearch root" do
  user "root"
  cwd "/tmp"
  code %(cp -r /tmp/elasticsearch-#{node[:elasticsearch][:version]}/* /usr/lib/elasticsearch-#{node[:elasticsearch][:version]})
  not_if { File.exists? "/usr/lib/elasticsearch-#{node[:elasticsearch][:version]}/lib" }
end

directory "/usr/lib/elasticsearch-#{node[:elasticsearch][:version]}/plugins" do
  owner "root"
  group "root"
  mode 0755
end

link "/usr/lib/elasticsearch" do
  to "/usr/lib/elasticsearch-#{node[:elasticsearch][:version]}"
end

aws = nil
if node[:ec2]
  aws = data_bag_item('aws', 'main')

  directory "/mnt/elasticsearch" do
    owner "elasticsearch"
    group "nogroup"
    mode 0755
  end

  # put lib dir on /mnt
  mount "/var/lib/elasticsearch" do
    device "/mnt/elasticsearch"
    fstype "none"
    options "bind,rw"
    action :mount
  end
end

bash "copy elasticsearch conf" do
  user "root"
  cwd "/usr/lib/elasticsearch"
  code %(cp -R ./config/* /etc/elasticsearch)
  not_if { File.exists? "/etc/elasticsearch/logging.yml" }
end

template "/etc/elasticsearch/logging.yml" do
  source "logging.yml.erb"
  mode 0644
end

template "/etc/elasticsearch/elasticsearch.in.sh" do
  source "elasticsearch.in.sh.erb"
  mode 0644
end

template "/etc/elasticsearch/elasticsearch.yml" do
  source "elasticsearch.yml.erb"
  owner "elasticsearch"
  group "nogroup"
  variables(:aws => aws)
  mode 0600 # could have aws keys in it
end

runit_service "elasticsearch" do
  action [ :enable, :start ]
end
