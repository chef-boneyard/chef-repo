#
# Cookbook Name:: barbican-base
# Recipe:: newrelic
#

# Configure server-related NewRelic instrumentation:
include_recipe 'newrelic::repository'
include_recipe 'newrelic::server-monitor'


# Prepare for Newrelic plugin usage:

include_recipe "python::#{node['python']['install_method']}"
include_recipe "python::pip"

#install the meet me newrelic plugin agent
python_pip node[:meetme_newrelic_plugin][:package_name] do
  action :install
end

directory node[:meetme_newrelic_plugin][:run_dir] do
  owner node[:meetme_newrelic_plugin][:user]
  group node[:meetme_newrelic_plugin][:group]
  mode 0774
end

directory node[:meetme_newrelic_plugin][:log_dir] do
  owner node[:meetme_newrelic_plugin][:user]
  group node[:meetme_newrelic_plugin][:group]
  mode 0774
end

template "/etc/init/newrelic_plugin_agent.conf" do
  source "newrelic_plugin_agent.upstart-rhel.erb"
  owner node[:meetme_newrelic_plugin][:user]
  group node[:meetme_newrelic_plugin][:group]
  mode 0774
  variables(
    :config_file => node[:meetme_newrelic_plugin][:config_file]
  )
end

# Defer to the application-specific setup:
#service "newrelic_plugin_agent" do
#  provider Chef::Provider::Service::Upstart
#  supports :restart => true, :start => true, :stop => true, :status => true
#  action :enable
#end
#
#template node[:meetme_newrelic_plugin][:config_file] do
#  source "newrelic_plugin_agent.cfg.erb"
#  variables(
#    :license_key => node[:newrelic][:application_monitoring][:license],
#    :poll_interval => node[:meetme_newrelic_plugin][:poll_interval],
#    :user => node[:meetme_newrelic_plugin][:user],
#    :log_file => "#{node[:meetme_newrelic_plugin][:log_dir]}/#{node[:meetme_newrelic_plugin][:log_file]}",
#    :run_dir => node[:meetme_newrelic_plugin][:run_dir]
#  )
#  action :create_if_missing
#  owner node[:meetme_newrelic_plugin][:user]
#  group node[:meetme_newrelic_plugin][:group]
#  mode 0774
#  notifies :start, resources(:service => "newrelic_plugin_agent")
#end

# At this point, we should be able to install application-specific NewRelic plugins.
