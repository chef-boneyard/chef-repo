name "test_server"
description "This role contains nodes, which act as web servers"
run_list "recipe[my_ntp]","recipe[my_cookbook]"
default_attributes 'ntp' => {
  'ntpdate' => {
    'disable' => true
    }
  }
default_attributes "my_cookbook" => {
  "role"    => "test_server"
}
