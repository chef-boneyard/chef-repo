name 'wistia-base'
description 'base configuration on top of which all wistia boxes are constructed'

SSH_USERS = %w(
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

run_list(
  'recipe[wistia-base]',
  'recipe[sudo]',
  'recipe[ssh-keys]'
)

default_attributes(
  'authorization' => {
    'sudo' => {
      'users' => ['ubuntu'],
      'passwordless' => true
    }
  },
  'ssh_keys' => {
    # Please keep users sorted by last name
    'ubuntu' => SSH_USERS,
    'root' => SSH_USERS
  }
)
