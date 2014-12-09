name              'ntp'
maintainer        'Opscode, Inc.'
maintainer_email  'cookbooks@opscode.com'
license           'Apache 2.0'
description       'Installs and configures ntp as a client or server'
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           '1.6.9'

recipe 'ntp', 'Installs and configures ntp either as a server or client'

%w( amazon centos debian fedora freebsd gentoo redhat scientific solaris2 oracle ubuntu windows xcp ).each do |os|
  supports os
end

suggests 'windows'

attribute 'ntp',
          :display_name => 'NTP',
          :description  => 'Hash of NTP attributes',
          :type         => 'hash'

attribute 'ntp/servers',
          :display_name => 'NTP Servers',
          :description  => 'Array of servers we should talk to',
          :type         => 'array',
          :default      => ['0.pool.ntp.org', '1.pool.ntp.org', '2.pool.ntp.org', '3.pool.ntp.org'],
          :required     => 'recommended'

attribute 'ntp/peers',
          :display_name => 'NTP Peers',
          :description  => 'Array of local NTP servers, we should peer with',
          :type         => 'array',
          :default      => [],
          :required     => 'recommended'

attribute 'ntp/restrictions',
          :display_name => 'Restriction lines',
          :description  => 'Array of restriction lines to apply to NTP servers',
          :type         => 'array',
          :default      => [],
          :required     => 'recommended'
