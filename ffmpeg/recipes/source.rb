#
# Cookbook Name:: ffmpeg
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

include_recipe "libvpx::source"

yasm_package = value_for_platform(
  [ "ubuntu" ] => { "default" => "yasm" },
  "default" => "yasm"
)

package yasm_package do
  action :upgrade
end

# Filter the packages that we just built from source via their compile flag
flags_for_upgrade = node[:ffmpeg][:compile_flags].reject do |flag| 
  ["--enable-libx264", "--enable-libvpx"].include?(flag)
end

find_prerequisite_packages_by_flags(flags_for_upgrade).each do |pkg|
  package pkg do
    action :upgrade
  end
end

bash "compile_ffmpeg" do
  action :nothing
  cwd "#{Chef::Config[:file_cache_path]}/ffmpeg"
  code <<-EOH
    ./configure --prefix=#{node[:ffmpeg][:prefix]} #{node[:ffmpeg][:compile_flags].join(' ')}
    make clean && make && make install
  EOH
  creates "#{node[:ffmpeg][:prefix]}/bin/ffmpeg"
end

git "#{Chef::Config[:file_cache_path]}/ffmpeg" do
  repository node[:ffmpeg][:git_repository]
  reference node[:ffmpeg][:git_revision]
  action :sync
  notifies :run, resources(:bash => "compile_ffmpeg")
end

# Write the flags used to compile the application to Disk. If the flags
# do not match those that are in the compiled_flags attribute - we recompile
template "#{Chef::Config[:file_cache_path]}/ffmpeg-compiled_with_flags" do
  source "compiled_with_flags.erb"
  owner "root"
  group "root"
  mode 0600
  variables(
    :compile_flags => node[:ffmpeg][:compile_flags]
  )
  notifies :run, resources(:bash => "compile_ffmpeg")
end
