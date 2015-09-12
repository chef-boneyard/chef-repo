#
# Cookbook Name:: nfs
# Recipe:: export
#
# Custom recipe distributed along with other artifacts in the Emulab's Chef Repoistory
# For more info, see: https://github.com/emulab/chef-repo

# Run configuration from the recipe in the dependency cookbook
include_recipe 'nfs::server'

directory node['nfs']['export']['dir'] do
  action :create
end

nfs_export node['nfs']['export']['dir'] do
  network	node['nfs']['export']['network']
  writeable	node['nfs']['export']['writeable']
  sync		node['nfs']['export']['sync']
  options	node['nfs']['export']['options']
end
