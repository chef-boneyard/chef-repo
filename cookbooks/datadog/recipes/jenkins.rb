include_recipe 'datadog::dd-agent'

# Integrate jenkins builds
#
# To configure the integration of one or more jenkins servers into Datadog
# simply set up attributes for the jenkins nodes or roles like so:
#
# node.datadog.jenkins.instances = [
#                                   {
#                                     "name" => "dev-jenkins",
#                                     "home" => "/var/lib/jenkins/dev"
#                                   },
#                                   {
#                                     "name" => "prod-jenkins",
#                                     "home" => "/var/lib/jenkins/prod"
#                                   }
#                                  ]
#
# Note that this check can only monitor local jenkins instances

datadog_monitor 'jenkins' do
  instances node['datadog']['jenkins']['instances']
end
