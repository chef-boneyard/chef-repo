#
# Cookbook Name:: datadog
# Recipe:: hdfs
#

# Monitor hdfs
#
# Assuming you have 2 instances "prod" and "test", you will need to set
# up the following attributes at some point in your Chef run, in either
# a role or another cookbook.
#
# node["datadog"]["hdfs"]["instances"] = [
#   {
#     "fqdn" => "hdfs.prod.tld",
#     "port" => "8020",
#     "tags" => ["prod", "hdfs_core"]
#   },
#   {
#     "fqdn" => "hdfs.test.tld",
#     "port" => "8020",
#     "tags" => ["test"]
#   }
# ]

include_recipe 'datadog::dd-agent'

datadog_monitor 'hdfs' do
  instances node['datadog']['hdfs']['instances']
end
