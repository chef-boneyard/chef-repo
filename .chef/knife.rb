# Configure knife for your organization here.  This file should be managed by a version control system.
# Configure local knife options in '.chef/knife.local.rb'. The file 'knife.local.rb' should NOT be managed by version control.

# See http://docs.opscode.com/config_rb_knife.html for more information on knife configuration options

# Variable that starts the path of the current directory
current_dir = File.dirname(__FILE__)

#-------------------------------------------------------------------------------
#  Log Configuration
#-------------------------------------------------------------------------------

log_level                :info
log_location             STDOUT


#-------------------------------------------------------------------------------
#  Connection/Validation Configuration
#-------------------------------------------------------------------------------

# The URL for the Chef Server. For example: "http://localhost:4000"
chef_server_url          "https://api.opscode.com/organizations/ORGNAME"

# The location of the file which contains the key used when a chef-client is registered with a Chef Server. A validation key is signed using the validation_client_name for authentication.
validation_key           "#{current_dir}/ORGNAME-validator.pem", __FILE__)

# The name of the server that–along with the validation_key–is used to determine whether a chef-client may register with a Chef Server. The validation_client_name located in the server and client configuration files must match.
validation_client_name   "ORGNAME-validator"


#-------------------------------------------------------------------------------
#  Cache Configuration
#-------------------------------------------------------------------------------

cache_type               'BasicFile'
cache_options( :path => "#{ENV['HOME']}/.chef/checksums" )


#-------------------------------------------------------------------------------
#  Cookbook Configuration
#-------------------------------------------------------------------------------

# The sub-directory for cookbooks on the chef-client. This value can be a string or an array of file system locations, processed in the specified order. The last cookbook is considered to override local modifications.
cookbook_path [
  "#{current_dir}/../cookbooks",
  "#{current_dir}/../site-cookbooks"
]

# The name of the copyright holder. This option will place a copyright notice that contains the name of the copyright holder in each of the pre-created files. If this option is not specified, a copyright name of “your_company_name” will be used instead; it can be easily modified later.
cookbook_copyright "your_company_name"

# The type of license under which a cookbook is distributed: apachev2, gplv2, gplv3, mit, or none (default). This option will place the appropriate license notice in the pre-created files. Be aware of the licenses for files inside of a cookbook and be sure to follow any restrictions they describe.
cookbook_license "none"

# The email address for the individual who maintains the cookbook. This option will place an email address in each of the pre-created files. If this option is not specified, an email name of “your_email” will be used instead; it can be easily modified later.
cookbook_email "your_email"

# Format of the README file, supported formats are 'md' (markdown) and 'rdoc' (rdoc)
# readme_format "md"


#-------------------------------------------------------------------------------
#  Data Bag Encryption Configuration
#-------------------------------------------------------------------------------

# The minimum required version of data bag encryption. Possible values: 1 or 2. When all of the machines in an organization are running chef-client version 11.6 (or higher), it is recommended that this value be set to 2.
# data_bag_encrypt_version "2"


#-------------------------------------------------------------------------------
#  Local Configuration Options
#-------------------------------------------------------------------------------

if ::File.exist?("#{current_dir}/knife.local.rb")
  Chef::Config.from_file("#{current_dir}/knife.local.rb")
end
