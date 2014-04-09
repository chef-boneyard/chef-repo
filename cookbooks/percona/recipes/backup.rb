node.set["percona"]["backup"]["configure"] = true

include_recipe "percona::package_repo"

case node["platform_family"]
when "debian"
  package "xtrabackup" do
    options "--force-yes"
  end
when "rhel"
  package "percona-xtrabackup"
end

# access grants
include_recipe "percona::access_grants"
