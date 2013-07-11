# ** SAMPLE LOCAL Knife Configuration File - Copy to knife.local.rb and edit that file instead of this one!! **

# Configure organization-wide knife options in '.chef/knife.rb'. The file '.chef/knife.rb' should be managed by a version control system.
# Configure local knife options in '.chef/knife.local.rb'. The file '.chef/knife.local.rb' should NOT be managed by version control. If you use git, '.chef/knife.local.rb' has already been ignored.

# Local configuration options are the options that will only be specific to a single user or to a group of users.  For example, developers
# may be given credentials for a private data center like Eucalyptus or OpenStack so that they may provision servers in a controlled
# environment; systems administrators may be given credentials to a public cloud like Amazon or Rackspace so that they may provision production
# servers...  Likewise, an organization may only choose to share an encryption secret with systems administrators and not developers (or they
# may choose to share a different secret with the developers)

# See http://docs.opscode.com/config_rb_knife.html for more information on knife configuration options

#-------------------------------------------------------------------------------
#  LOCAL Connection/Validation Configuration
#-------------------------------------------------------------------------------

# The name of the node. This is typically also the same name as the computer from which Knife is run.
node_name                "USERNAME"

# The location of the file which contains the client key.
client_key               "#{current_dir}/USERNAME.pem"

#-------------------------------------------------------------------------------
#  LOCAL Data Bag Encryption Configuration
#-------------------------------------------------------------------------------

# The path to the file that contains the encryption key. IMPORTANT: Make sure that you tell your VCS to ignore this file. If you use git, it has already been ignored.
# encrypted_data_bag_secret "#{current_dir}/encrypted_data_bag_secret"

#-------------------------------------------------------------------------------
#  Cloud Credentials
#-------------------------------------------------------------------------------

# Amazon EC2
# knife[:aws_access_key_id]  = "Your AWS Access Key ID"
# knife[:aws_secret_access_key] = "Your AWS Secret Access Key"

# Microsoft Azure
# knife[:azure_subscription_id] = 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'
# knife[:azure_mgmt_cert] = '/path/to/your/mgmtCert.pem'
# knife[:azure_api_host_name] = 'management.core.windows.net'
# knife[:azure_service_location] = 'West US'
# knife[:azure_dns_name]='myservice'
# knife[:azure_vm_name]='myvm02'
# knife[:ssh_user]='jetstream'
# knife[:identity_file]='/path/to/RSA/private/key'
# knife[:azure_storage_account]='auxpreview104'
# knife[:azure_os_disk_name]='disk107'
# knife[:tcp_endpoints]='66'
# knife[:udp_endpoints]='77,88,99'

# Bluelock
# knife[:bluelock_username] = "Your Bluelock Account Username"
# knife[:bluelock_password] = "Your Bluelock Account Password"

# Eucalyptus
# knife[:euca_access_key_id]     = "Your Eucalyptus Access Key ID"
# knife[:euca_secret_access_key] = "Your Eucalyptus Secret Access Key"
# knife[:euca_api_endpoint]      = "http://ecc.eucalyptus.com:8773/services/Eucalyptus"

# HP Cloud
# knife[:hp_access_key] = "Your HP Cloud Access Key ID"
# knife[:hp_secret_key] = "Your HP Cloud Secret Key"
# knife[:hp_tenant_id]  = "Your HP Cloud Tenant ID"
# knife[:hp_auth_uri]   = "Your HP Cloud Auth URI" (optional, default is 'https://region-a.geo-1.identity.hpcloudsvc.com:35357/v2.0/')
# knife[:hp_avl_zone]   = "Your HP Cloud Availability Zone" (optional, default is 'az1', choices are 'az1', 'az2' or 'az3')

# Linode
# knife[:linode_api_key] = "Your Linode API Key"

# OpenStack
# knife[:openstack_username] = "Your OpenStack Dashboard username"
# knife[:openstack_password] = "Your OpenStack Dashboard password"
# knife[:openstack_auth_url] = "http://cloud.mycompany.com:5000/v2.0/tokens" # Note: If you are not proxying HTTPS to the OpenStack auth port, the scheme should be HTTP
# knife[:openstack_tenant] = "Your OpenStack tenant name"

# Rackspace
# knife[:rackspace_api_username] = "Your Rackspace API username"
# knife[:rackspace_api_key] = "Your Rackspace API Key"

# Terremark
# knife[:terremark_username] = "Your Terremark Account Username"
# knife[:terremark_password] = "Your Terremark Account Password"
