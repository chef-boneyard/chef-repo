name 'queue'
description 'Queue role recipes'
run_list(
    'recipe[rabbitmq::default]'
)
override_attributes(
)
