name 'distillery-collector'
description 'configures a distillery-collector box (in progress)'
run_list(
  'role[distillery-base]'
)
default_attributes(
)
