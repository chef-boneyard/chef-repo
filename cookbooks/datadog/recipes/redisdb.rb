include_recipe 'datadog::dd-agent'

datadog_monitor 'redisdb' do
  instances node['datadog']['redisdb']['instances']
end
