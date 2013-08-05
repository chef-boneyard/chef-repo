name 'distillery-base'
description 'configures a base distillery box (in progress)'
run_list(
  'role[wistia-base]'
)
default_attributes(
  'authorization' => {
    'sudo' => {
      'users' => ['distillery'] # This gets merged with the base role
    }
  }
)

