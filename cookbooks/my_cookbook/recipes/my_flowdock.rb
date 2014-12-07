include_recipe 'chef_handler'

gem_package('chef-handler-flowdock'){action :nothing}.run_action(:install)

chef_handler 'Chef::Handler::FlowdockHandler' do
  action :enable
  attributes :api_token => "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",
             :from => {:name => "YOUR_NAME", :address => "YOUR_EMAIL"}
  source File.join(Gem::Specification.find{|s| s.name == 'chef-handler-flowdock'}.gem_dir,
    'lib', 'chef', 'handler', 'flowdock_handler.rb')
end
