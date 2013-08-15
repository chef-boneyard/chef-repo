name 'base'
description 'Base role for all servers'
run_list(
    'recipe[cloudpassage]',
    'recipe[newrelic::repository]',
    'recipe[newrelic::server-monitor]',
    'recipe[yum::epel]'
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
