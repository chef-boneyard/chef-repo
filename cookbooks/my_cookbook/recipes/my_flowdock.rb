include_recipe 'chef_handler'


gem_package('chef-handler-flowdock'){action :nothing}.run_action(:install)

template '/var/chef/handlers/flowdock.rb' do
  source 'flowdock.rb.erb' 
  mode 0755
end




#template '/etc/chef/client.rb' do
#  source 'client.rb.erb' 
#  variables(
#    api_token: '536e1ad158d6bef37e0b1b77590da91a'
#  )
#end


