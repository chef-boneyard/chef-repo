name "chef-upgrade"
description "Use this role to upgrade Chef clients and server with the Opscode Chef cookbook. Requires that nodes are using chef::client or chef::server recipes."

# Update the version number to upgrade Chef to a newer version.
# You may need to add an override attribute under 'chef' for 'server_path'
# depending on your installation, eg:
#   "server_path" => "/usr/lib/ruby/gems/1.8/gems/chef-server-0.7.10"
# On the line after server_version. Don't forget the comma ;).
override_attributes(
  "chef" => {
    "client_version"=>"0.7.10",
    "server_version"=>"0.7.10"
  }
)
