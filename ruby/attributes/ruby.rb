include_attribute 'opsworks_initial_setup::default'
include_attribute 'opsworks_commons::default'


default[:ruby][:major_version] = '2.0'
default[:ruby][:full_version] = '2.0.0'
default[:ruby][:patch] = 'p247'
default[:ruby][:pkgrelease] = '1'

default[:ruby][:version] = "#{default[:ruby][:full_version]}#{default[:ruby][:patch]}"
default[:ruby][:executable] = '/usr/local/bin/ruby'

arch = RUBY_PLATFORM.match(/64/) ? 'amd64' : 'i386'
default[:ruby][:deb] = "ruby#{default[:ruby][:major_version]}_#{default[:ruby][:full_version]}-#{default[:ruby][:patch]}.#{default[:ruby][:pkgrelease]}_#{arch}.deb"
default[:ruby][:deb_url] = "#{default[:opsworks_commons][:assets_url]}/packages/#{default[:platform]}/#{default[:platform_version]}/#{default[:ruby][:deb]}"

rhel_arch = RUBY_PLATFORM.match(/64/) ? 'x86_64' : 'i686'
default[:ruby][:rpm] = "ruby#{default[:ruby][:major_version].delete('.')}-#{default[:ruby][:full_version]}-#{default[:ruby][:patch]}-#{default[:ruby][:pkgrelease]}.#{rhel_arch}.rpm"
default[:ruby][:rpm_url] = "#{default[:opsworks_commons][:assets_url]}/packages/#{default[:platform]}/#{default[:platform_version]}/#{default[:ruby][:rpm]}"
