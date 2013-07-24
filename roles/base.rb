name 'base'
description 'Base role for all servers'
run_list(
    'recipe[yum::epel]',
    'recipe[chef-cloudpassage]'
)
override_attributes(
    'cloudpassage' => {
        'repository_key' => '12345694a24da434d6fdf0bf271ad361',
        'licence_key' => '999999999999999999999999'
    }
)
