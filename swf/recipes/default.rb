git "#{Chef::Config[:file_cache_path]}/swf" do
  repository node[:swf][:git_repository]
  reference node[:swf][:git_revision]
  action :sync
end

gem_package "bundle" do
  action :install
end

execute "bundle_install" do
  command "cd #{Chef::Config[:file_cache_path]}/swf;/usr/local/bin/bundle install"
end

template "#{Chef::Config[:file_cache_path]}/swf/config/aws.yml" do
  source "aws.erb"
  variables :aws => {
    :access_key => node[:AWS_ACCESS_KEY],
    :secret => node[:AWS_SECRET_ACCESS_KEY]
  }
  action :create
end

execute "start_god" do
  command "god -c #{Chef::Config[:file_cache_path]}/swf/swf.god && sleep 5"
end

execute "restart_god_workers" do
  command "god restart workers"
end

