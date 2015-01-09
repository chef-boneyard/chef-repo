include_recipe 'datadog::dd-agent'

datadog_monitor 'lighttpd' do
  instances node['datadog']['lighttpd']['instances']
end
