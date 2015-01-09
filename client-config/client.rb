log_level        :info
log_location     STDOUT
chef_server_url  'https://api.opscode.com/organizations/papi'
validation_client_name 'papi-validator'

require '/var/chef/handlers/flowdock_handler'
exception_handlers << Chef::Handler::FlowdockHandler.new(:api_token => "536e1ad158d6bef37e0b1b77590da91a")
