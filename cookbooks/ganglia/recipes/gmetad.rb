case node[:platform]
when "ubuntu", "debian"
  package "gmetad"
when "redhat", "centos", "fedora"
  include_recipe "ganglia::source"
  execute "copy gmetad init script" do
    command "cp " +
      "/usr/src/ganglia-#{node[:ganglia][:version]}/gmetad/gmetad.init " +
      "/etc/init.d/gmetad"
    not_if "test -f /etc/init.d/gmetad"
  end
end

directory "/var/lib/ganglia/rrds" do
  owner "nobody"
  recursive true
end

ips = search(:node, "recipes:ganglia").map {|node| node.ipaddress}

template "/etc/ganglia/gmetad.conf" do
  source "gmetad.conf.erb"
  variables( :hosts => ips.join(" "),
             :cluster_name => node[:ganglia][:cluster_name])
  notifies :restart, "service[gmetad]"
end

service "gmetad" do
  supports :restart => true
  action [ :enable, :start ]
end
