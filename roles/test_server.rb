name "test_server"
description "This role contains nodes, which act as web servers"
run_list "recipe[ntp]"
default_attributes 'ntp' => {
  'ntpdate' => {
    'disable' => true
    }
  }
default_attributes "my_cookbook" => {
  "role"    => "test_server"
}
