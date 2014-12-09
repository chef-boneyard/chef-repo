::Chef::Resource::RubyBlock.send(:include, MinitestHandler::CookbookHelper)

chef_gem 'ci_reporter' do
  version node[:minitest][:ci_reporter_gem_version]
  action :nothing
end.run_action(:install)

# Hack to install Gem immediately pre Chef 0.10.10 (CHEF-2879)
chef_gem 'minitest' do
  version node[:minitest][:gem_version]
  action :nothing
  only_if { Chef::VERSION.to_f < 10.10 }
end.run_action(:install)

chef_gem 'minitest-chef-handler' do
  version node[:minitest][:chef_handler_gem_version]
  action :nothing
  # I won't pretend I understand WHY this works, but since the release of
  # Chef 11.8, this was causing errors related to the PUMA Gem
  # http://lists.opscode.com/sympa/arc/chef/2013-10/msg00592.html
  # I tried using the conservative flag, as well as a few other hacks
  # but for whatever reason, simply retrying once works. The initial
  # attempt still fails with the error in that thread, however
  # the retry succeeds...
  retries 1
end.run_action(:install)

Gem.clear_paths
# Ensure minitest gem is utilized
require 'minitest-chef-handler'

[:delete, :create].each do |action|
  directory "#{action} minitest test location" do
    path node[:minitest][:path]
    owner node[:minitest][:owner]
    group node[:minitest][:group]
    mode node[:minitest][:mode]
    recursive true
    action action
  end
end

# Search through all cookbooks in the run list for tests
ruby_block 'load_tests_and_register_handler' do
  block do
    load_tests
    register_handler
  end
end
