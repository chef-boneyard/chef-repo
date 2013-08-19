name 'distillery-collector'
description 'configures a distillery-collector box (in progress)'
run_list(
  'role[distillery-base]',
  'recipe[distillery-collector]'
)

PRIVATE_DEPLOY_KEY = <<EOS
-----BEGIN RSA PRIVATE KEY-----
MIIEpAIBAAKCAQEAt0BjHR0BxS5mcuh/qi95qTfR3M467pgrD/V14rBrlmq24Pc3
XPjoBA18zphmrLdW0lq3PT/moPDVqUrSVs/Z0e5/k8W1m+edirTj8bHhPDRoVYI4
1Flwpp6StuQP/xvElEVvUOee/6zs8/62sAvKRYQJTB+pqxSoWuE1viIyr9Xuz/8p
ieZszCOwvKEVO6xgb2Hgn0bDnpSFbcfE3/RpanajYwd5gtSmaojrlKV6uAvsPKsT
2Ljm2Gjw4o0GTM4uo2euOLwJolKlGumFwDF+HJlOFEJP5wohfEopV0PSc2QO/O39
yJyT8PY0Bg2tw7F9uYjgV0Be4XCZd8IDFlFNSQIDAQABAoIBAQCxX75P8MLE5Fu/
v7HKvfdJxsD4tBmw1lNgOBwqFs+coaBwcnoBIOAbBB8ZLcS8Sx3bsHkK7S5D+7kk
C0s7Qia5H9wW4dkelfsUxnCYgq/cAXI3yjtNt2DltjmWk3u0V2FYjzjnG7r4CZ61
sYeNMWxRCzOgnkkxUmZ+yNynNBzRumMIO6vioGa2yh+/JpQcSn/ohGa7LR9RLusu
p5sH45Dh3OcvAdwMC/BuXd0iktiwl32j54AzSX1xBsXx1pX80uvjqiEhdH+8j1mb
ubKTqOFr00zIAUNWaHip6oa9wuoySVYUdSrrgiGQs+qeagiUjqD7HxKiljq6r2JB
qWeY3titAoGBANj0z3ond0dMRpTBhBiZqiw1kVgrR4F8tCe020md0q6yILz3e1lV
kh5/MRMhZTCvUtDIP0xLUXmSwe+7OfMGi2u9doxKrDB6J6prH0kLRi9aD8UwgEny
Kus47G1aAyzllygUA8skf3SZ+raKq8aD8IvFkju0BS1KelD5fcBkAryTAoGBANg6
y6ZFVxWu3ggC8viLl59OnfMQYNRpFIA6i3+hhgQAU/Vw6iGhR7oVv5I6gJFONjkM
6zEgDlAva1JdNckQ0T2Dq5hxG7hmRIxdS+eXAViMKIYcp/GT8/yxgG4UkE5dBg6e
ACA6UdC35moxwgMFFDCbauPs+pP4dluqkz2hdNQzAoGAGRb+o3bK8YDdrLhQaXPj
3Sb4vwSKSWw9fVYKAhJxWeiZpqDMMAGYW1SEPV0gUagE4MY3o8AWFQQmz22MfxFj
sDsB6al9DkIiMjAfNxhJrpIwvrIkM+kAk6FKnj7JnTiT6XufELAQ2VAxUUjqIpQB
jnhzt9nSu3EgghrIMyadtmcCgYEAs4p2aJQw0BdH0x0nxEqcVjIAIsAZtqWd2S9D
f3GOBqqDDEx6i/wPw6qlS/T5pi1sBoj8jOjSGbCWC2jL7SzioJJBHC3m14FLL8WT
7jNLccvHJjyLEqNINyznt/+pJvhEvERjVF84afcZAlpYfwtrjUSvR5wRIGZxWIHV
CpqSmFMCgYB+4/MfmdXm6XmfubZFg7p9q7hsWExEjS2Kz51njnzuNSKIh8L3XeWx
aewy3ycwhp3Ah5WaM0hR2/fA44qUwi/Z/fCuNk58CmKXqDwLHqeKQspvVvyW6n+B
KWpCZSISqzmIJasrhzK3bYpJpgGD/G7vxUWBw1oOfC49o5VRTCXBPg==
-----END RSA PRIVATE KEY-----
EOS

default_attributes(
  'combine' => {
    'deploy_private_key' => PRIVATE_DEPLOY_KEY,
    'stats_db' => {
      'host' => 'localhost',
      'port' => 40000,
      'name' => 'stats',
      'collection' => 'counters'
    },
    'queue_db' => {
      'host' => 'localhost',
      'port' => 40000,
      'name' => 'monque',
      'collection' => 'monque'
    }
  },

  'mongodb' => {
    'client_role' => 'distillery-thresher',
    'logappend' => true,
    'pidfilepath' => '/var/lib/mongodb/collector.pid',
    'port' => 40000
  },

  'haproxy' => {
    'app_server_role' => 'distillery-collector',
    'balance_algorithm' => 'roundrobin',
    'daemon' => true,
    'defaults_options' => ['httplog', 'redispatch', 'httpclose', 'dontlognull'],
    'defaults_timeouts' => {
      'client' => 60000,
      'connect' => 4000,
      'server' => 60000
    },
    'global_max_connections' => 10000,
    'listeners' => [
      {
        'name' => 'http_balance',
        'bind_location' => ':80',
        'balance' => 'roundrobin',
        'options' => ['forwardfor except 127.0.0.1 except 10.182.172.213'],
        'additional_headers' => [{ 'key' => 'X-Forwarded-Proto', 'value' => 'http' }],
        'servers' => [
          { 'name' => 'c1', 'ip' => '127.0.0.1', 'port' => 3000, 'weight' => 1, 'maxconn' => 5000 },
          { 'name' => 'c2', 'ip' => '127.0.0.1', 'port' => 3001, 'weight' => 1, 'maxconn' => 5000 },
          { 'name' => 'c3', 'ip' => '127.0.0.1', 'port' => 3002, 'weight' => 1, 'maxconn' => 5000 },
        ]
      },

      {
        'name' => 'https_balance',
        'bind_location' => '127.0.0.1:8443',
        'balance' => 'roundrobin',
        'options' => ['forwardfor except 127.0.0.1'],
        'additional_headers' => [{ 'key' => 'X-Forwarded-Proto', 'value' => 'https' }],
        'servers' => [
          { 'name' => 'c1', 'ip' => '127.0.0.1', 'port' => 3000, 'weight' => 1, 'maxconn' => 5000 },
          { 'name' => 'c2', 'ip' => '127.0.0.1', 'port' => 3001, 'weight' => 1, 'maxconn' => 5000 },
          { 'name' => 'c3', 'ip' => '127.0.0.1', 'port' => 3002, 'weight' => 1, 'maxconn' => 5000 },
        ]
      }
    ],
    'pid_file' => '/var/run/haproxy.pid',
    'source' => {
      'target_arch' => 'x86_64',
      'target_os' => 'linux26',
      'use_pcre' => true,
      'version' => '1.4.24'
    },
    'stats' => {
      'uri' => '/haproxy?stats',
      'auth' => 'admin:m4dmin'
    },
    'ulimit-n' => 65536,
    'use_listeners' => true,
    'x_forwarded_for' => true
  }
)
