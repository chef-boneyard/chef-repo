include_recipe 'chef_handler'

gem_package('chef-handler-flowdock'){action :nothing}.run_action(:install)

chef_handler 'Chef::Handler::FlowdockHandler' do

  action :enable
  attributes :api_token => "536e1ad158d6bef37e0b1b77590da91a",
             :from => {:name => "Michael", :address => "levmichael3@gmail.com"}
  source File.join(Gem::Specification.find{|s| s.name == 'chef-handler-flowdock'}.gem_dir,
    'lib', 'chef', 'handler', 'flowdock_handler.rb')

end
