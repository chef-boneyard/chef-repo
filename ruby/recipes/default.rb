# ToDo: define an attribute for the version

local_ruby_up_to_date = ::File.exists?('/usr/local/bin/ruby') && system("#{'/usr/local/bin/ruby'} -v | grep -q '2.1.2'")

if local_ruby_up_to_date
  Chef::Log.info("Userspace Ruby version is 2.1.2 - up-to-date")
elsif !::File.exists?('/usr/local/bin/ruby')
  Chef::Log.info("Userspace Ruby version is not 2.1.2 - /usr/local/bin/ruby does not exist")
else
  Chef::Log.info("Userspace Ruby version is not 2.1.2 - found #{`#{'/usr/local/bin/ruby'} -v`}")
end

case node['platform']
when 'debian','ubuntu'
  # remote_file "/tmp/ruby2.0_2.0.0-p247.1_amd64.deb" do
  #   source 'https://s3.amazonaws.com/share-yesvideo/static/ruby2.0_2.0.0-p247.1_amd64.deb'
  #   action :create_if_missing
  #
  #   not_if do
  #     local_ruby_up_to_date
  #   end
  # end

  ['libreadline6', 'libreadline6-dev'].each do |pkg|
    package pkg do
      action :install
    end
  end

  remote_file "/tmp/ruby-2.1.2.medium_build.tar.gz" do
    source 'https://s3.amazonaws.com/share-yesvideo/static/ruby-2.1.2.medium_build.tar.gz'
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
       ::File.exists?("/tmp/ruby-2.1.2.medium_build.tar.gz")
      end
    end
  end
end

execute "Extract Ruby 2.1.2" do
  cwd "/tmp"

  command "tar -xvpf /tmp/ruby-2.1.2-compiled.tar.gz"

  only_if do
    ::File.exists?("/tmp/ruby-2.1.2-compiled.tar.gz")
  end
end

execute "Install Ruby 2.1.2" do
  Chef::Log.info("Installing Ruby 2.1.2...")

  cwd "/tmp/ruby-2.1.2"
  command "sudo make install"
end

# execute 'Delete downloaded ruby packages' do
#   command "rm -f /tmp/ruby-2.1.2-compiled.tar.gz"
#   only_if do
#      ::File.exists?("/tmp/ruby-2.1.2-compiled.tar.gz")
#    end
# end

#execute 'Delete install location' do
#  command "rm -rf /tmp/ruby-2.1.2"
#  only_if do
#    ::File.exists?("/tmp/ruby-2.1.2")
#  end
#end

include_recipe 'opsworks_rubygems'
include_recipe 'opsworks_bundler'
