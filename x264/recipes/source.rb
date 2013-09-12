#
# Cookbook Name:: x264
# Recipe:: source
#
# Author:: Jamie Winsor (<jamie@vialstudios.com>)
#
# Copyright 2011, En Masse Entertainment, Inc.
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

include_recipe "build-essential"
include_recipe "git"

x264_packages.each do |pkg|
  package pkg do
    action :purge
  end
end

yasm_package = value_for_platform(
  [ "ubuntu" ] => { "default" => "yasm" },
  "default" => "yasm"
)

package yasm_package do
  action :upgrade
end

git "#{Chef::Config[:file_cache_path]}/x264" do
  repository node[:x264][:git_repository]
  reference node[:x264][:git_revision]
  action :sync
  notifies :run, "bash[compile_x264]"
end

# Write the flags used to compile the application to disk. If the flags
# do not match those that are in the compiled_flags attribute - we recompile
template "#{Chef::Config[:file_cache_path]}/x264-compiled_with_flags" do
  source "compiled_with_flags.erb"
  owner "root"
  group "root"
  mode 0600
  variables(
    :compile_flags => node[:x264][:compile_flags]
  )
  notifies :run, "bash[compile_x264]"
end

bash "compile_x264" do
  cwd "#{Chef::Config[:file_cache_path]}/x264"
  code <<-EOH
    ./configure --prefix=#{node[:x264][:prefix]} #{node[:x264][:compile_flags].join(' ')}
    make clean && make && make install
  EOH
  creates "#{node[:x264][:prefix]}/bin/x264"
end
