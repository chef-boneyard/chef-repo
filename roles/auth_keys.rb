# Configures authorize_keys role.

name 'auth_keys'
description 'Configure Github access ssh keys on a server'
run_list(
    'recipe[authorized_keys]'
)
override_attributes(
    'authorized_keys' => {
        'databag_name' => 'github_key_user',
        'databag_item' => 'auth'
    }
)
