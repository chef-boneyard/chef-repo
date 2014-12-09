include_recipe 'chef_handler'


gem_package('chef-handler-flowdock'){action :nothing}.run_action(:install)

file '/var/chef/handlers/flowdock.rb' do
#   source 'flowdock' 
   mode 0755
 end



#api_token => "536e1ad158d6bef37e0b1b77590da91a",

