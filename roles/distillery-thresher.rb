name 'distillery-thresher'
description 'configures a distillery-thresher box (in progress)'
run_list(
  'role[distillery-base]'
)
default_attributes(
)
