#
# Cookbook Name:: barbican
# Recipe:: _newrelic
#

# Configure server-related NewRelic instrumentation:
include_recipe 'newrelic::repository'
include_recipe 'newrelic::server-monitor'


#prepare for Newrelic plugin usage:

#install Python/pip
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

# At this point, we are ready to install application-specific NewRelic plugins.
