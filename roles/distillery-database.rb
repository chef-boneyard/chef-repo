name 'distillery-database'
description 'configures a distillery-database box (in progress)'
run_list(
  'role[distillery-base]'
)
default_attributes(
)
