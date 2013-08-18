#
# Cookbook Name:: distillery-collector
# Recipe:: default
#
# Copyright 2013, Wistia, Inc.
#
# All rights reserved - Do Not Redistribute
#

name 'distillery-collector'
description 'configures a distillery-collector box (in progress)'
run_list(
  'role[distillery-base]',
  'recipe[ruby_build]',
  'recipe[haproxy::app_lb]',
  'recipe[logrotate]',
  'recipe[mongodb::10gen_repo]',
  'recipe[mongodb]'
)

template '/etc/haproxy/haproxy.cfg' do
  source 'haproxy-app_lb.cfg.erb'
end

template '/etc/mongodb.conf' do
  source 'mongodb.default.erb'
end
