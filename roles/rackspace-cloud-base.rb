name 'rackspace-cloud-base'
description 'ensures rackspace cloud compatibility'
run_list(
  'recipe[rackconnect]'
)
default_attributes(
  'authorization' => {
    'sudo' => {
      'include_sudoers_d' => true
    }
  }
)
