name             "yasm"
maintainer       "Escape Studios"
maintainer_email "dev@escapestudios.com"
license          "MIT"
description      "Installs/Configures Yasm"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.4"

%w{ debian ubuntu centos redhat fedora scientific amazon }.each do |os|
supports os
end

depends "build-essential"
depends "git"

recipe "yasm", "Installs Yasm."
recipe "yasm::package", "Installs Yasm using packages."
recipe "yasm::source", "Installs Yasm from source."