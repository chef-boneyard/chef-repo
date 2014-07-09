# ToDo: define an attribute for the version

local_ruby_up_to_date = ::File.exists?('/usr/local/bin/ruby') && system("#{'/usr/local/bin/ruby'} -v | grep -q '#{node[:ruby][:version]}'")

if local_ruby_up_to_date
  Chef::Log.info("Userspace Ruby version is #{node[:ruby][:version]} - up-to-date")
elsif !::File.exists?('/usr/local/bin/ruby')
  Chef::Log.info("Userspace Ruby version is not #{node[:ruby][:version]} - /usr/local/bin/ruby does not exist")
else
  Chef::Log.info("Userspace Ruby version is not #{node[:ruby][:version]} - found #{`#{'/usr/local/bin/ruby'} -v`}")
end

case node['platform']
when 'debian','ubuntu'
  ['libreadline6', 'libreadline6-dev'].each do |pkg|
    package pkg do
      action :install
    end
  end

  remote_file "#{node[:ruby][:install_dir]}/#{node[:ruby][:distro]}" do
    source "https://s3.amazonaws.com/share-yesvideo/static/#{node[:ruby][:distro]}"
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
       ::File.exists?("#{node[:ruby][:install_dir]}/#{node[:ruby][:distro]}")
      end
    end
  end
end

execute "Extract Ruby #{node[:ruby][:version]}" do
  cwd "#{node[:ruby][:install_dir]}"

  command "tar -xvpf #{node[:ruby][:install_dir]}/#{node[:ruby][:distro]}"

  only_if do
    ::File.exists?("#{node[:ruby][:install_dir]}/#{node[:ruby][:distro]}")
  end
end

execute "Install Ruby #{node[:ruby][:version]}" do
  Chef::Log.info("Installing Ruby #{node[:ruby][:version]}...")

  cwd "#{node[:ruby][:install_dir]}/ruby-#{node[:ruby][:version]}"
  command "sudo make install"
end

# execute 'Delete downloaded ruby packages' do
#   command "rm -f #{node[:ruby][:install_dir]}/#{node[:ruby][:distro]}"
#   only_if do
#      ::File.exists?("#{node[:ruby][:install_dir]}/#{node[:ruby][:distro]}")
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
