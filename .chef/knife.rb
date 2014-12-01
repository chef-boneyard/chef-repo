# See https://docs.chef.io/config_rb_knife.html for more information on knife configuration options



current_dir = File.dirname(__FILE__)
log_level                :info
log_location             STDOUT
node_name                "levmichael1979"
client_key               "#{current_dir}/levmichael1979.pem"
validation_client_name   "papi-validator"
validation_key           "#{current_dir}/papi-validator.pem"
chef_server_url          "https://api.opscode.com/organizations/papi"
cache_type               'BasicFile'
cache_options( :path => "#{ENV['HOME']}/.chef/checksums" )
cookbook_path            ["#{current_dir}/../cookbooks"]
cookbook_copyright 	 "papi"
cookbook_license  	 "none"
cookbook_email 		 "levmichael3@gmail.com" 
