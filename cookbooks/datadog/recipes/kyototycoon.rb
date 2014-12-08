include_recipe 'datadog::dd-agent'

# Integrate Kyoto Tycoon metrics into Datadog
#
# To configure, simply set atributes according to the following example
#
# node.datadog.kyototycoon.instances = [
#                                       {
#                                         "name" => "dev",
#                                         "report_url" => "http://localhost:1978/rpc/report",
#                                         "tags" => { "key1" => "value1", "key2" => "value2" }
#                                       },
#                                       {
#                                         "name" => "prod",
#                                         "report_url" => "http://localhost:2978/rpc/report",
#                                         "tags" => { "key3" => "value3", "key4" => "value4" }
#                                       }
#                                      ]

datadog_monitor 'kyototycoon' do
  instances node['datadog']['kyototycoon']['instances']
end
