name 'distillery-api'
description 'configures a distillery-api box (in progress)'
run_list(
  'role[distillery-base]'
)
default_attributes(
)
