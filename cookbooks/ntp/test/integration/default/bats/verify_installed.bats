@test 'ntp is up and running' {
  pgrep ntp
}

@test 'ntp.conf contains correct servers' {
	grep 0.pool.ntp.org /etc/ntp.conf
}
