name 'distillery-backups'
description 'configures a distillery-backups box (in progress)'
run_list(
  'role[distillery-base]'
)
default_attributes(
)
