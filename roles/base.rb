name 'base'
description 'Base role for all servers'
run_list(
    'recipe[yum::epel]'
)
