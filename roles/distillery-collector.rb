name 'distillery-collector'
description 'configures a distillery-collector box (in progress)'
run_list(
  'role[distillery-base]',
  'recipe[haproxy]',
  'recipe[logrotate]',
  'recipe[mongodb::10gen_repo]',
  'recipe[mongodb]'
)
default_attributes(
  'mongodb' => {
    'port' => 40000
  }
)
