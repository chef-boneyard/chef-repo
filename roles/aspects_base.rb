# Configures external aspects to applications, such as installing 
# CloudPassage and New Relic. Note that more specific 'aspect_xxxx.rb'
# roles still need to be run depending on the type of node to manage.

name 'aspects_base'
description 'Aspect configuration for all servers'
run_list(
    'recipe[chef-cloudpassage]'
#    'recipe[newrelic::repository]',
#    'recipe[newrelic::server-monitor]'
)
override_attributes(
    'cloudpassage' => {
        'license_key' => 'fbce1e35339345f48556c7a9a0d23205',
        'tag' => 'test-api-tag'
#        'license_key' => 'get from a data bag or provide key here',
#        'tag' => 'get from a data bag or provide tag here'
    },
    'newrelic' => {
        'server_monitoring' => {
            'license' => 'get from a data bag or provide key here',
            'logfile' => '/var/log/barbican/newrelic.log',
            'loglevel' => 'debug'
        }
    }
)
