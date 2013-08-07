name 'base'
description 'Base role for all servers'
run_list(
    'recipe[chef-cloudpassage]',
    'recipe[newrelic::repository]',
    'recipe[newrelic::server-monitor]',
    'recipe[yum::epel]'
)
override_attributes(
    'cloudpassage' => {
        'license_key' => 'TODO: get from data bag or provide here'
    },
    'newrelic' => {
        'server_monitoring' => {
            'license' => 'TODO: get from data bag or provide here',
            'logfile' => '/var/log/barbican/newrelic.log',
            'loglevel' => 'debug'
        }
    }
)
