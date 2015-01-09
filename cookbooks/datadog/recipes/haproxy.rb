include_recipe 'datadog::dd-agent'

# Monitor haproxy

# You need to set up the following attributes
# node.datadog.haproxy.instances = [
#                                     {
#                                       :url => "http://localhost/stats_url",
#                                       :username => "username",
#                                       :password => "secret",
#                                       :status_check => false,
#                                       :collect_aggregates_only => true,
#                                       :collect_status_metrics => true
#                                     }
#                                    ]

datadog_monitor 'haproxy' do
  instances node['datadog']['haproxy']['instances']
end
