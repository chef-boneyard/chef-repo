#
# Cookbook Name:: distillery-collector
# Recipe:: default
#
# Copyright 2013, Wistia, Inc.
#
# All rights reserved - Do Not Redistribute
#

######
# RUBY
######
RUBY_BUILD_VERSION = '1.9.2-p290'

include_recipe 'ruby_build'

ruby_build_ruby RUBY_BUILD_VERSION do
  action :install
end

RUBY_BIN_PATH = ::File.join(node['ruby_build']['default_ruby_base_path'], RUBY_BUILD_VERSION, 'bin')

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
