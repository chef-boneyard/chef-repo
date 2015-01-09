include_recipe 'datadog::dd-agent'

# Monitor network
#
# node.datadog.network.instances = [
#   {
#     :collect_connection_state => "false",
#     :excluded_interfaces => ["lo","lo0"]
#   },
# ]

Chef::Log.warn 'Datadog network check only supports one `instance`, please check attribute assignments' if node['datadog']['network']['instances'].count > 1

datadog_monitor 'network' do
  instances node['datadog']['network']['instances']
end
