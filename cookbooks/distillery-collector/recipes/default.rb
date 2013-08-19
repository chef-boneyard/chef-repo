#
# Cookbook Name:: distillery-collector
# Recipe:: default
#
# Copyright 2013, Wistia, Inc.
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'ruby_build'
include_recipe 'haproxy::app_lb'
include_recipe 'logrotate'
include_recipe 'mongodb::10gen_repo'
include_recipe 'mongodb'

begin
  r = resources(template: "#{node['haproxy']['conf_dir']}/haproxy.cfg")
  r.cookbook 'distillery-collector'
rescue Chef::Exceptions::ResourceNotFound
  Chef::Log.warn 'could not find haproxy template to override!'
end

begin
  r = resources(template: '/etc/mongodb.conf')
  r.cookbook 'distillery-collector'
rescue Chef::Exceptions::ResourceNotFound
  Chef::Log.warn 'could not find mongo template to override!'
end
