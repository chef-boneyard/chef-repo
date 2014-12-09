name             'my_cookbook'
maintainer       'Papi Company'
maintainer_email 'levmichael3@gmail.com'
license          'Apache 2.0'
description      'Installs/Configures my_cookbook'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.3'

#added
depends "chef-client"
depends "iptables"
#depends "ntp-cookbook"
depends "chef_handler"
