name 'api'
description 'Role for the Barbican API'
run_list(
    'recipe[python::pip]',
    'recipe[newrelic::python-agent]'
)
override_attributes(
    'newrelic' => {
        'application_monitoring' => {
            'license' => 'TODO: get from data bag or provide here',
            'enabled' => true,
            'logfile' => '/var/log/newrelic/newrelic.log',
            'loglevel' => 'debug',
            'appname' => 'barbican-api'
        }
    }
)
