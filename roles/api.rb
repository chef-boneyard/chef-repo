name 'api'
description 'Role for the Barbican API'
run_list(
    'recipe[python::pip]'
)
override_attributes(
    'node_group' => {
        'description' => 'Barbican API Node',
        'tag' => 'api'
    }
)
