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

knife[:server_create_timeout] = 1800 # half hour

RACKSPACE_DFW_ENDPOINT = 'https://dfw.servers.api.rackspacecloud.com/v2'
RACKSPACE_ORD_ENDPOINT = 'https://ord.servers.api.rackspacecloud.com/v2'
RACKSPACE_LON_ENDPOINT = 'https://lon.servers.api.rackspacecloud.com/v2'

knife[:rackspace_auth_url] = 'https://identity.api.rackspacecloud.com/v2.0'
knife[:rackspace_endpoint] = RACKSPACE_ORD_ENDPOINT
knife[:rackspace_api_username] = ENV['WISTIA_RACKSPACE_USERNAME']
knife[:rackspace_api_key] = ENV['WISTIA_RACKSPACE_API_KEY']

knife[:aws_access_key_id] = ENV['WISTIA_AWS_ACCESS_KEY_ID']
knife[:aws_secret_access_key] = ENV['WISTIA_AWS_SECRET_ACCESS_KEY']
