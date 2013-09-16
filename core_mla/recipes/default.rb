git "#{Chef::Config[:file_cache_path]}/core_mla" do
  repository node[:core_mla][:git_repository]
  reference node[:core_mla][:git_revision]
  action :sync
end

rpm_package "core_mla" do
  source "#{Chef::Config[:file_cache_path]}/core_mla/CoreMLA-1.0.0-1.x86_64.rpm"
  action :install
end

