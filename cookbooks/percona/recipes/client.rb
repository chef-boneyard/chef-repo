include_recipe "percona::package_repo"
include_recipe "mysql::client"

if platform_family?('debian')
  chef_gem "chef-rewind"
  require 'chef/rewind'

  node['mysql']['client']['packages'].each do |pkg|
    rewind :package => pkg do
      options "--force-yes"
    end
  end
end
