#
# Cookbook Name:: distillery-collector
# Recipe:: default
#
# Copyright 2013, Wistia, Inc.
#
# All rights reserved - Do Not Redistribute
#

# Allows us to override templates
chef_gem 'chef-rewind'
require 'chef/rewind'

# Ensure our apt cache is no more than one day old
include_recipe 'apt'

######
# RUBY
######
node.set['rbenv']['ruby_build_version'] = '1.9.2-p290'

include_recipe 'rbenv::default'
include_recipe 'rbenv::ruby_build'

rbenv_ruby node['rbenv']['ruby_build_version'] do
  global true
end

rbenv_gem 'bundler' do
  ruby_version node['rbenv']['ruby_build_version']
end

#########
# MONGODB
#########
include_recipe 'mongodb::10gen_repo'
include_recipe 'mongodb::default'

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
node.set['combine']['deploy_dir'] = '/opt/apps/combine'

application 'combine' do
  path node['combine']['deploy_dir']
  repository 'git@github.com:wistia/combine.git'
  revision 'jb-remove-daemon'
  deploy_key node['combine']['deploy_private_key']

  action :deploy
end

template 'combine-db-config' do
  path ::File.join(node['combine']['deploy_dir'], 'current', 'database_config.rb')
  source 'combine-db-config.rb.erb'
end

execute 'set-log-directory-permissions' do
  command %Q(chmod a+rwx -R #{node['combine']['deploy_dir']}/current/log && chmod a-x -R #{node['combine']['deploy_dir']}/current/log/*)
end

execute 'bundle-install' do
  command %Q(bundle install)
  cwd '/opt/apps/combine/current'
end

#######
# RUNIT
#######

include_recipe 'runit'

node['combine']['ports'].each do |port|
  runit_service "combine-#{port}" do
    log false
    run_template_name 'combine'

    options({
      :port => port
    })
  end
end


#########
# HAPROXY
#########
include_recipe 'haproxy::app_lb'

rewind "template[#{node['haproxy']['conf_dir']}/haproxy.cfg]" do
  cookbook_name 'distillery-collector'
  source 'haproxy-app_lb.cfg.erb'
end


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


###########
# LOGROTATE
###########
include_recipe 'logrotate'
