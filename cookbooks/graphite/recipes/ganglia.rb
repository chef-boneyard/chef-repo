include_recipe "graphite"
include_recipe "ganglia::gmetad"

target = "/opt/graphite/storage/rrd/#{node.ganglia.cluster_name}"

directory target do
  mode "755"
end

Dir.glob("/var/lib/ganglia/rrds/#{node.ganglia.cluster_name}/*.*").each do |path|
  source = File.basename(path).gsub(".", "_")
  link "#{target}/#{source}" do
    to path
  end
end
