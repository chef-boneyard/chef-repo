#
# Cookbook Name:: ntp
# Recipe:: apparmor
# Author:: Scott Lampert (<scott@lampert.org>)
#
# Copyright 2013, Scott Lampert
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

service 'apparmor' do
  action :nothing
end

cookbook_file '/etc/apparmor.d/usr.sbin.ntpd' do
  source 'usr.sbin.ntpd.apparmor'
  owner 'root'
  group 'root'
  mode '0644'
  notifies :restart, 'service[apparmor]'
end
