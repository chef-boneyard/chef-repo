#
# Cookbook Name:: nfs
# Recipe:: mount
#
# Custom recipe distributed along with other artifacts in the Emulab's Chef Repoistory	
# For more info, see: https://github.com/emulab/chef-repo

# Run configuration from the recipe in the dependency cookbook
include_recipe 'nfs::default'

directory node['nfs']['mount']['dir'] do
  action :create
end

mount node['nfs']['mount']['dir'] do
  device node['nfs']['mount']['source']
  fstype 'nfs'
  options node['nfs']['mount']['options']
  action [:mount, :enable]
end
