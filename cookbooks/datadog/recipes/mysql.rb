include_recipe 'datadog::dd-agent'

# Monitor mysql
#
# Assuming you have 1 mysql instance "prod"  on a given server, you will need to set
# up the following attributes at some point in your Chef run, in either
# a role or another cookbook.
#
# node['datadog']['mysql']['instances'] = [
#   {
#     'server' => "localhost",
#     'user' => "my_username",
#     'pass' => "my_password",
#     'sock' => "/path/to/mysql.sock",
#     'tags' => ["prod"],
#     'options' => [
#       "replication: 0",
#       "galera_cluster: 1"
#     ]
#   },
# ]

datadog_monitor 'mysql' do
  instances node['datadog']['mysql']['instances']
end
