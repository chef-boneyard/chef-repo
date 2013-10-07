#
# Cookbook Name:: barbican-db
# Recipe:: newrelic
#

include_recipe 'barbican-base::newrelic'

#install the Python PostgreSQL driver
python_pip "psycopg2" do
  action :install
end

#define newrelic-plugin-agent service
service "newrelic_plugin_agent" do
  provider Chef::Provider::Service::Upstart
  supports :restart => true, :start => true, :stop => true, :status => true
  action :enable
end

template node[:meetme_newrelic_plugin][:config_file] do
  source "postgres.newrelic_plugin_agent.cfg.erb"
  owner node[:meetme_newrelic_plugin][:user]
  group node[:meetme_newrelic_plugin][:group]
  mode 0774
  variables(
    :license_key => node[:newrelic][:application_monitoring][:license],
    :poll_interval => node[:meetme_newrelic_plugin][:poll_interval],
    :user => node[:meetme_newrelic_plugin][:user],
    :log_file => "#{node[:meetme_newrelic_plugin][:log_dir]}/#{node[:meetme_newrelic_plugin][:log_file]}",
    :run_dir => node[:meetme_newrelic_plugin][:run_dir],
    :dbhost => node[:meetme_newrelic_plugin][:postgres][:host],
    :dbname => node[:meetme_newrelic_plugin][:postgres][:dbname],
    :dbport => node[:meetme_newrelic_plugin][:postgres][:port],
    :dbuser => node[:meetme_newrelic_plugin][:postgres][:user],
    :dbpassword => node[:meetme_newrelic_plugin][:postgres][:password],
    :db_is_superuser_needed => node[:meetme_newrelic_plugin][:postgres][:is_superuser_needed],
    :db_is_relation_stats_needed => node[:meetme_newrelic_plugin][:postgres][:is_relation_stats_needed] 
  )
  notifies :start, resources(:service => "newrelic_plugin_agent")
end
