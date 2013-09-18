name 'api'
description 'Role for the Barbican API'
run_list(
    'recipe[python::pip]'
)
