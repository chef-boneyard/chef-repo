name 'blank_box'
description 'for creating blank boxes on demand for whatever you need to do'
run_list(
  'recipe[ssh-keys]',
  'recipe[getting-started]'
)

default_attributes(
  'ssh_keys' => {
    'ubuntu' => ['robby']
  }
)
