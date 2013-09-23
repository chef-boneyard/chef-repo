name 'worker'
description 'Role for the Barbican Worker'
run_list(
    'recipe[python::pip]'
)
override_attributes(
    'node_group' => {
        'description' => 'Barbican Worker Node',
        'tag' => 'worker'
    }
)
