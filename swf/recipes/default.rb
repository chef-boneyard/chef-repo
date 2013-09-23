git "#{Chef::Config[:file_cache_path]}/swf" do
  repository node[:swf][:git_repository]
  reference node[:swf][:git_revision]
  action :sync
end

execute "start_god" do
  command "god -c #{Chef::Config[:file_cache_path]}/swf/swf.god"
end

