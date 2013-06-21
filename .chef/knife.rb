current_dir = File.dirname(__FILE__)

log_level :info
log_location STDOUT

node_name ENV['WISTIA_CHEF_USERNAME']
client_key "#{current_dir}/#{ENV['WISTIA_CHEF_USERNAME']}.pem"

validation_client_name   'chef-validator'
validation_key           "#{current_dir}/chef-validator.pem"
chef_server_url          'https://chef.wistia.com'
cache_type               'BasicFile'
cache_options(path: '~/.chef/checksums')
cookbook_path            ["#{current_dir}/../cookbooks"]

knife[:rackspace_api_username] = ENV['WISTIA_RACKSPACE_USERNAME']
knife[:rackspace_api_key] = ENV['WISTIA_RACKSPACE_API_KEY']
knife[:aws_access_key_id] = nil
knife[:aws_secret_access_key] = nil
