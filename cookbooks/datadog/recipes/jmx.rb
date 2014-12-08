include_recipe 'datadog::dd-agent'

datadog_monitor 'jmx' do
  instances node['datadog']['jmx']['instances']
end
