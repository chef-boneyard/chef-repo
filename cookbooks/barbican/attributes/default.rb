default['barbican_api']['host_name'] = 'localhost'
default['barbican_api']['db_name'] = 'barbican_api'
default['barbican_api']['db_user'] = 'barbican'
set['ntp']['servers'] = ['time.rackspace.com']

include_attribute "newrelic"
include_attribute "newrelic::repository"
include_attribute "newrelic::server-monitor"
