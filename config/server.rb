#
# Chef Server Config File
#

log_level          :info
log_location       STDOUT
ssl_verify_mode    :verify_none
registration_url   "http://chef:4000"
openid_url         "http://chef:4001"
template_url       "http://chef:4000"
remotefile_url     "http://chef:4000"
search_url         "http://chef:4000"
cookbook_path      [ "/var/chef/site-cookbooks", "/var/chef/cookbooks" ]
merb_log_path      "/var/log/chef-server-merb.log"

Chef::Log::Formatter.show_time = false
