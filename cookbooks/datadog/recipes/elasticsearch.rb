include_recipe 'datadog::dd-agent'

# Monitor elasticsearch
#
# Assuming you have 2 clusters "test" and "prod",
# one with and one without authentication
# you need to set up the following attributes
# node.datadog.elasticsearch.instances = [
#                                         {
#                                          :url => "http://localhost:9200"
#                                         },
#                                         {
#                                          :url => "http://localhost:19200"
#                                         }
#                                        ]

datadog_monitor 'elastic' do
  instances node['datadog']['elasticsearch']['instances']
end
