#
# Cookbook Name:: barbican-worker
# Recipe:: default
#
# Note that the yum repository configuration used here was found at this site:
#   http://docs.opscode.com/resource_cookbook_file.html
#

include_recipe "barbican-base"

package 'barbican-common'

package 'barbican-worker'


