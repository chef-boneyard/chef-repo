# Configures external aspects to applications, such as installing 
# CloudPassage and New Relic. Note that more specific 'aspect_xxxx.rb'
# roles still need to be run depending on the type of node to manage.

name 'aspects_base'
description 'Aspect configuration for all servers'
run_list(
    'recipe[cloudpassage]'
#    'recipe[newrelic::repository]',
#    'recipe[newrelic::server-monitor]'
)
override_attributes(
    'cloudpassage' => {
        'license_key' => 'get from a data bag or provide key here'
    },
    'newrelic' => {
        'server_monitoring' => {
            'license' => 'get from a data bag or provide key here',
            'logfile' => '/var/log/barbican/newrelic.log',
            'loglevel' => 'debug'
        }
    }
)
