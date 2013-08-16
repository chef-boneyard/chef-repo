name 'distillery-collector'
description 'configures a distillery-collector box (in progress)'
run_list(
  'role[distillery-base]',
  'recipe[distillery-collector]',
  'recipe[haproxy::app_lb]',
  'recipe[logrotate]',
  'recipe[mongodb::10gen_repo]',
  'recipe[mongodb]'
)
default_attributes(
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
