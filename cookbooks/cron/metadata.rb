name             "cron"
maintainer       "Opscode, Inc."
maintainer_email "cookbooks@opscode.com"
license          "Apache 2.0"
description      "Installs cron"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "1.2.6"

%w{redhat centos scientific fedora amazon debian ubuntu}.each do |os|
  supports os
end
