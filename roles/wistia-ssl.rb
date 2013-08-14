name 'wistia-ssl'
description 'installs wistia ssl keys on server'
run_list(
  'role[wistia-base]',
  'recipe[ssl]'
)
default_attributes(
  'ssl' => {
    'group' => 'root'
  }
)
