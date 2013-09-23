local_ruby_up_to_date = ::File.exists?('/usr/local/bin/ruby') && system("#{'/usr/local/bin/ruby'} -v | grep -q '2.0.0'")

if local_ruby_up_to_date
  Chef::Log.info("Userspace Ruby version is 2.0.0 - up-to-date")
elsif !::File.exists?('/usr/local/bin/ruby')
  Chef::Log.info("Userspace Ruby version is not 2.0.0 - /usr/local/bin/ruby does not exist")
else
  Chef::Log.info("Userspace Ruby version is not 2.0.0 - found #{`#{'/usr/local/bin/ruby'} -v`}")
end

case node['platform']
when 'debian','ubuntu'
  remote_file "/tmp/ruby2.0_2.0.0-p247.1_amd64.deb" do
    source 'https://s3.amazonaws.com/share-yesvideo/static/ruby2.0_2.0.0-p247.1_amd64.deb'
    action :create_if_missing

    not_if do
      local_ruby_up_to_date
    end
  end

  ['ruby-enterprise','ruby1.9','ruby2.0'].each do |pkg|
    package pkg do
      action :remove
      ignore_failure true

      only_if do
       ::File.exists?("/tmp/ruby2.0_2.0.0-p247.1_amd64.deb")
      end
    end
  end
end

execute "Install Ruby 2.0.0" do
  cwd "/tmp"

  command "dpkg -i /tmp/ruby2.0_2.0.0-p247.1_amd64.deb"
  only_if do
    ::File.exists?("/tmp/ruby2.0_2.0.0-p247.1_amd64.deb")
  end

end

execute 'Delete downloaded ruby packages' do
  command "rm -vf /tmp/ruby2.0_2.0.0-p247.1_amd64.deb"
  only_if do
     ::File.exists?("/tmp/ruby2.0_2.0.0-p247.1_amd64.deb")
   end
end

include_recipe 'opsworks_rubygems'
include_recipe 'opsworks_bundler'
