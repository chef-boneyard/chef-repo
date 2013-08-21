#
# Cookbook Name:: distillery-collector
# Recipe:: default
#
# Copyright 2013, Wistia, Inc.
#
# All rights reserved - Do Not Redistribute
#

# Ensure our apt cache is no more than one day old
include_recipe 'apt'

######
# RUBY
######
RUBY_BUILD_VERSION = '1.9.2-p290'

include_recipe 'rbenv::default'
include_recipe 'rbenv::ruby_build'
include_recipe 'rbenv::rbenv_vars'
include_recipe 'rbenv::ohai_plugin'

rbenv_ruby RUBY_BUILD_VERSION do
  global true
end

rbenv_gem 'bundler' do
  ruby_version RUBY_BUILD_VERSION
end

#########
# MONGODB
#########
include_recipe 'mongodb::10gen_repo'
include_recipe 'mongodb'

begin
  r = resources(template: '/etc/mongodb.conf')
  r.cookbook 'distillery-collector'
rescue Chef::Exceptions::ResourceNotFound
  Chef::Log.warn 'could not find mongo template to override!'
end

# configure monque collections and indices
MONQUE_URL = "#{node['combine']['queue_db']['host']}:#{node['combine']['queue_db']['port']}/#{node['combine']['queue_db']['name']}"
MONQUE_INIT_SCRIPT = [
  "db.createCollection('monque')",
  "db.createCollection('workers')",
  "db.createCollection('failures')",
  "db.monque.ensureIndex({ queue: 1 })",
  "db.workers.ensureIndex({ worker: 1 })"
].join(';')

execute 'init-monque-collections' do
  command %Q(mongo #{MONQUE_URL} --eval "#{MONQUE_INIT_SCRIPT}")
end

#########
# COMBINE
#########
COMBINE_DEPLOY_DIR = '/opt/apps/combine'
node.set['combine']['deploy_dir'] = COMBINE_DEPLOY_DIR

application 'combine' do
  path COMBINE_DEPLOY_DIR
  repository 'git@github.com:wistia/combine.git'
  revision 'master'
  deploy_key node['combine']['deploy_private_key']

  action :deploy
end

template 'combine-db-config' do
  path ::File.join(COMBINE_DEPLOY_DIR, 'current', 'database_config.rb')
  source 'combine-db-config.rb.erb'
end

COMBINE_PORTS = [3000, 3001, 3002]


#######
# RUNIT
#######

#include_recipe 'runit'

=begin
COMBINE_PORTS.each do |port|
  runit_service "combine-#{port}" do
  end
end
=end


#####
# GOD
#####

=begin
COMBINE_PORTS.each do |port|
  god_monitor "combine-#{port}" do
    config "combine-#{port}.god.erb"
  end
end
=end


#########
# HAPROXY
#########
include_recipe 'haproxy::app_lb'

begin
  r = resources(template: "#{node['haproxy']['conf_dir']}/haproxy.cfg")
  r.cookbook 'distillery-collector'
rescue Chef::Exceptions::ResourceNotFound
  Chef::Log.warn 'could not find haproxy template to override!'
end

###########
# LOGROTATE
###########
include_recipe 'logrotate'
