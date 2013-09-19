#
# Cookbook Name:: barbican-queue
# Recipe:: default
#
# Note that the yum repository configuration used here was found at this site:
#   http://docs.opscode.com/resource_cookbook_file.html
#

# Do anything needed beyond the standard rabbit mq install here

include_recipe "barbican-base"

rabbitmq_user "guest" do
  password "guest"
  action :add
end