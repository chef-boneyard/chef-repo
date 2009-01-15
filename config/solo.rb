#
# Chef Solo Config File
#

log_level          :info
log_location       STDOUT
file_cache_path    "/var/chef/cookbooks"
ssl_verify_mode    :verify_none
Chef::Log::Formatter.show_time = false
