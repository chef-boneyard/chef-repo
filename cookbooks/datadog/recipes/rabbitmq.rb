include_recipe 'datadog::dd-agent'

# Integrate rabbitmq metrics into Datadog
#
# Set up attributes following this example.
# If you are running multiple rabbitmq instances on the same machine
# list them all as hashes.
#
# node.datadog.rabbitmq.instances = [
#                                    {
#                                      "api_url" => "http://localhost:15672/api/",
#                                      "user" => "guest",
#                                      "pass" => "guest"
#                                    }
#                                   ]

datadog_monitor 'rabbitmq' do
  instances node['datadog']['rabbitmq']['instances']
end
