include_recipe 'datadog::dd-agent'

# Monitor apache
#
# Assuming you have 2 instances "prod" and "test", you will need to set
# up the following attributes at some point in your Chef run, in either
# a role or another cookbook.
#
# node['datadog']['apache']['instances'] = [
#   {
#     'status_url' => "http://localhost:81/status/",
#     'tags' => ["prod"]
#   },
#   {
#     'status_url' => "http://localhost:82/status/",
#     'name' => ["test"]
#   }
# ]

datadog_monitor 'apache' do
  instances node['datadog']['apache']['instances']
end
