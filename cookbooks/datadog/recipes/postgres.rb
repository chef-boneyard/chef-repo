include_recipe 'datadog::dd-agent'

# Monitor postgres
#
# Simply declare the following attributes
# One instance per server.
#
# node['datadog']['postgres']['instances'] = [
#   {
#     'host' => "localhost",
#     'port' => "5432",
#     'username' => "datadog",
#     'tags' => ["test"]
#   },
#   {
#     'host' => "remote",
#     'port' => "5432",
#     'username' => "datadog",
#     'tags' => ["prod"],
#     'dbname' => 'my_database',
#     'relations' => ["apple_table", "orange_table"]
#   }
# ]

datadog_monitor 'postgres' do
  instances node['datadog']['postgres']['instances']
end
