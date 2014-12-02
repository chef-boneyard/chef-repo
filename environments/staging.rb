name "STAGING"
description 'The staging environment'

override_attributes(
  :ntp => { :servers => "0.europe.pool.ntp.org"}
)

