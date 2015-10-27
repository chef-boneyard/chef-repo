#
# Cookbook Name:: emulab-env
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# Install .profile with common and useful aliases
template "/root/.profile" do
  source 'profile.erb'
  mode 0644
  owner 'root'
  group 'root'
end

# Install and configure screen
apt_package "screen" do
  action :install
end
template "/root/.screenrc" do
  source 'screenrc.erb'
  mode 0644
  owner 'root'
  group 'root'
end
