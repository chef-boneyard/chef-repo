name "STAGING"
description 'The staging environment'

override_attributes ({
    "ntp" => {
      "servers" =>  ["0.asia.pool.ntp.org", "1.asia.pool.ntp.org", "2.asia.pool.ntp.org", "3.asia.pool.ntp.org"] 
    },
})

