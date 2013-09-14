name             'barbican-queue'
maintainer       'Rackspace, Inc.'
maintainer_email 'john.wood@rackspace.com'
license          'Apache License, Version 2.0'
description      'Installs/Configures barbican-queue'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'
depends          'rabbitmq'
depends          'barbican-base'