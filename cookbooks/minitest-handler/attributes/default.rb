# The version of the minitest gem to install
default[:minitest][:gem_version] = '3.0.1'

# The version of the minitest-chef-handler gem to install
default[:minitest][:chef_handler_gem_version] = '1.0.3'

# The version of the ci_reporter gem to install
default[:minitest][:ci_reporter_gem_version] = '1.9.2'

default[:minitest][:tests] = '**/*_test.rb'
default[:minitest][:recipes] = []
default[:minitest][:verbose] = true

case node[:os]
when 'windows'
  default[:minitest][:path] = '/var/chef/minitest'
  # Usin nil to prevent this from being applied on Windows
  default[:minitest][:owner] = nil
  default[:minitest][:group] = nil
  default[:minitest][:mode] = nil
else
  # Default values for Linux
  default[:minitest][:path] = '/var/chef/minitest'
  default[:minitest][:owner] = 'root'
  default[:minitest][:group] = 'root'
  default[:minitest][:mode] = '0775'
end
