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

include_recipe 'ntp::ntpdate'

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

include_recipe 'god'

god_monitor 'combines' do
  config 'combines.god.erb'
end


###########
# LOGROTATE
###########
include_recipe 'logrotate::global'

logrotate_app 'combines' do
  cookbook 'logrotate'
  path '/opt/apps/combine/current/log/combine.log'
  frequency 'weekly'
  rotate '52'
  options ['missingok', 'compress', 'delaycompress', 'notifempty']
  create '666 root root'
end

logrotate_app 'mongo' do
  cookbook 'logrotate'
  path '/var/log/mongodb/mongodb.log'
  frequency 'daily'
  rotate '52'
  options ['missingok', 'compress', 'delaycompress', 'notifempty']
  create '644 mongodb nogroup'
  # USR1 causes mongod to rotate and reopen the log file on its own, which causes
  # a 2nd (empty) copy to be made. The ugly find command removes this 2nd copy.
  # See http://viktorpetersson.com/2011/12/22/mongodb-and-logrotate/
  postrotate <<EOS
  killall -SIGUSR1 mongod
  find /var/log/mongodb/ -type f -regex ".*\.\(log.[0-9].*-[0-9].*\)" -exec rm {} \;
EOS
end
