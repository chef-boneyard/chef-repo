include_recipe 'datadog::dd-agent'

# Import cacti data
#
# Assuming you have 1 cacti server
# you need to set up the following attributes.
#
# The `rrd_whitelist` is a path to a text file that has a list of patterns,
# one per line, that should be fetched. If no whitelist is specified, all
# metrics will be fetched, which may be an expensive operation.
# We recommand that you set up a white list.
#
# node.datadog.cacti.instances = [
#                                 {
#                                  :mysql_host => "localhost",
#                                  :mysql_user => "cacti",
#                                  :mysql_password => "secret",
#                                  :rrd_path => "/path/to/rrd/rra",
#                                  :rrd_whitelist => "/path/to/rrd_whitelist.txt"
#                                 }
#                                ]

datadog_monitor 'cacti' do
  instances node['datadog']['cacti']['instances']
end
