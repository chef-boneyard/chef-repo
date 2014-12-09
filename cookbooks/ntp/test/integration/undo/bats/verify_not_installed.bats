@test 'ntp is not running' {
  run pgrep ntp
  [ "$status" -eq 1 ]
}
