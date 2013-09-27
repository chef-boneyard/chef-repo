name 'queue'
description 'Queue role recipes'
run_list(
)
override_attributes(
    'node_group' => {
        'description' => 'Barbican Queue Node',
        'tag' => 'queue'
    }
)
