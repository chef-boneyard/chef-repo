#
# Cookbook Name:: barbican-db
# Recipe:: default

#package 'postgresql-devel'
#include_recipe 'postgresql::server'
#include_recipe 'repmgr'

include_recipe "barbican-base"

# This connection info is used later in the recipe by the resources to connect to the DB
postgresql_connection_info = {:host => "localhost",
                              :port => "5432",
                              :username => 'postgres',
                              :password => node['postgresql']['password']['postgres']}

# Creates a database called 'barbican'
postgresql_database 'barbican_api' do
  connection postgresql_connection_info
  action :create
end

# Creates a user called 'barbican' and sets their password
database_user 'barbican' do
  connection postgresql_connection_info
  password 'barbpass'
  provider Chef::Provider::Database::PostgresqlUser
  action :create
end

#  Grants all privileges on 'barbican' to user 'barbican'
postgresql_database_user 'barbican' do
  connection postgresql_connection_info
  database_name 'barbican_api'
  privileges [:all]
  action :grant
end


