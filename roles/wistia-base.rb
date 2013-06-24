name 'wistia-base'
description 'base configuration on top of which all wistia boxes are constructed'
run_list(
  'recipe[ssh-keys]'
)

default_attributes(
  'ssh_keys' => {
    # Please keep users sorted by last name
    'ubuntu' => %w(
      jim-bancroft
      robby-grossman
      max-kohl
      jordan-munson
      ben-ruedlinger
      mary-schmidt
      max-schnur
      brendan-schwartz
      jeff-vincent
    )
  }
)
