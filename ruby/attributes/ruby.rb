include_attribute 'opsworks_initial_setup::default'
include_attribute 'opsworks_commons::default'

default[:ruby][:install_dir] = '/tmp'
default[:ruby][:version] = '2.1.2'
default[:ruby][:distro] = 'ruby-2.1.2-compiled.tar.gz'

