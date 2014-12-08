include_recipe 'datadog::dd-agent'

# Monitor cassandra
#
# Assuming you have 2 clusters "test" and "prod",
# one with and one without authentication
# you need to set up the following attributes
# node.datadog.cassandra.instances = [
#   {
#     :server => "localhost",
#     :port => "7199",
#     :name => "prod",
#     :username => "username",
#     :password => "secret"
#   },
#   {
#     :server => "localhost",
#     :port => "8199",
#     :name => "test"
#   }
# ]

datadog_monitor 'cassandra' do
  instances node['datadog']['cassandra']['instances']
end
