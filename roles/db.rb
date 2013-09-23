name 'db'
description 'Role for the Barbican Databases'
run_list(
)
override_attributes(
    'node_group' => {
        'description' => 'Barbican Database Node',
        'tag' => 'db'
    }
)
