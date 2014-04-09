include_recipe "percona::package_repo"

# Workaround a bug in the RPM packaging of percona-toolkit. Otherwise, it'll
#   try to pull in Percona-Server-shared-51, which will conflict with 5.5.
# https://bugs.launchpad.net/percona-toolkit/+bug/1031427
if node["platform_family"] == "rhel"
  package "Percona-Server-shared-compat"
end

package "percona-toolkit" do
  options "--force-yes" if platform_family?('debian')
end
