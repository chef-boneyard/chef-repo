set['postgresql']['enable_pgdg_yum'] = true
set['postgresql']['version'] = '9.2'
set['postgresql']['dir'] = '/var/lib/pgsql/9.2/data'
set['postgresql']['server']['packages'] = %w{ postgresql92-server }
set['postgresql']['server']['service_name'] = 'postgresql-9.2'
set['postgresql']['contrib']['packages'] = %w{ postgresql92-contrib }
set['postgresql']['config']['listen_addresses'] = '*'
set['postgresql']['pg_hba'] = [
  {
    :comment => "# 'local' is for Unix domain socket connections only",
    :type => 'local',
    :db => 'all',
    :user => 'postgres',
    :addr => nil,
    :method => 'ident'
  },
  {
    :type => 'local',
    :db => 'all',
    :user => 'all',
    :addr => nil,
    :method => 'ident'
  },
  {
    :comment => '# Open external comms with database',
    :type => 'host',
    :db => 'all',
    :user => 'all',
    :addr => '0.0.0.0/0',
    :method => 'md5'
  },
  {
    :comment => '# Open localhost comms with database',
    :type => 'host',
    :db => 'all',
    :user => 'all',
    :addr => '127.0.0.1/32',
    :method => 'trust'
  },
  {
    :comment => '# Open IPv6 localhost comms with database',
    :type => 'host',
    :db => 'all',
    :user => 'all', 
    :addr => '::1/128',
    :method => 'md5'
  }
]

