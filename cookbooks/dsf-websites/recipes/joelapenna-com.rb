#
# Cookbook Name:: dsf-websites
# Recipe:: joelapenna-com
#
# Copyright (C) 2013 Kevin Reedy
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

include_recipe "dsf-websites::default"

docroot = "/www/joelapenna.com"
owner = "root"
group = "root"

directory docroot do
  owner owner
  group group
end

template "#{ docroot }/index.html" do
  owner owner
  group group
  source "redirect.html.erb"
  variables({
    "redirect_to" => "http://blog.joelapenna.com"
  })
end

web_app "joelapenna.com" do
  server_name "joelapenna.com"
  server_aliases ["www.joelapenna.com"]
  docroot "/www/joelapenna.com"
  template "simple-site.conf.erb"
end
