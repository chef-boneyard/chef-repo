git "#{Chef::Config[:file_cache_path]}/core_mla" do
  repository node[:core_mla][:git_repository]
  reference node[:core_mla][:git_revision]
  action :sync
end

dpkg_package "core_mla" do
  source "#{Chef::Config[:file_cache_path]}/core_mla/coremla_1.0.0-2_amd64.deb"
  action :install
end

