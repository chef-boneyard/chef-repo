#
# Cookbook Name:: libvpx
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

libvpx_packages.each do |pkg|
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

git "#{Chef::Config[:file_cache_path]}/libvpx" do
  repository node[:libvpx][:git_repository]
  reference node[:libvpx][:git_revision]
  action :sync
  notifies :run, "bash[compile_libvpx]"
end

bash "compile_libvpx" do
  cwd "#{Chef::Config[:file_cache_path]}/libvpx"
  code <<-EOH
    ./configure --prefix=#{node[:libvpx][:prefix]}
    make clean && make && make install
  EOH
  creates "#{node[:libvpx][:prefix]}/bin/vpxenc"
end
