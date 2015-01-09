#
# Cookbook Name:: datadog
# Recipe:: repository
#
# Copyright 2013-2014, Datadog
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

case node['platform_family']
when 'debian'
  include_recipe 'apt'

  apt_repository 'datadog' do
    keyserver 'keyserver.ubuntu.com'
    key 'C7A7DA52'
    uri node['datadog']['aptrepo']
    distribution node['datadog']['aptrepo_dist']
    components ['main']
    action :add
  end

when 'rhel'
  include_recipe 'yum'

  yum_repository 'datadog' do
    name 'datadog'
    description 'datadog'
    url node['datadog']['yumrepo']
    gpgcheck false if respond_to? :gpgcheck
    action :add
  end
end
