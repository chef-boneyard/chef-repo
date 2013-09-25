# Configures ntpd.

name 'ntpd'
description 'Configure ntpd on a server'
run_list(
    'recipe[ntp]'
)
override_attributes(
    'ntp' => {
        'servers' => [
            'time.rackspace.com'
        ]
    }
)
