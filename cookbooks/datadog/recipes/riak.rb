include_recipe 'datadog::dd-agent'

# Monitor riak
#
# node.datadog.riak.instances = [
#   {
#     :url => "http://localhost:8098/stats",
#   }
# ]

datadog_monitor 'riak' do
  instances node['datadog']['riak']['instances']
end
