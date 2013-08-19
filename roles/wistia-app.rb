name 'wistia-app'
description 'configures a wistia app server (in progress)'
run_list(
  'role[wistia-base]'
)
default_attributes(
  'authorization' => {
    'sudo' => {
      'groups' => ['admin'], # This is how it's done in Doomcrank
      'users' => ['wistia'] # This is how we'll do it post-Doomcrank
    }
  }
)
