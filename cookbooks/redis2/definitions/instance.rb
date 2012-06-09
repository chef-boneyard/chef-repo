define :redis_instance, :port => nil, :data_dir => nil, :master => nil do
  include_recipe "redis2"
  instance_name = "redis_#{params[:name]}"
  # if no explicit replication role was defined, it's a master
  node.default_unless[:redis][:instances][params[:name]][:replication][:role] = "master"
  node[:redis][:instances][params[:name]] = {} unless node[:redis][:instances].has_key? params[:name]
  node[:redis][:instances][params[:name]][:port] = params[:port] unless params[:port].nil?
  node.default_unless[:redis][:instances][params[:name]][:port] = node[:redis][:instances][:default][:port]
  node[:redis][:instances][params[:name]][:data_dir] = params[:data_dir] unless params[:data_dir].nil?

  if (not node[:redis][:instances][params[:name]].has_key?(:data_dir)) or node[:redis][:instances][params[:name]][:data_dir] == node[:redis][:instances][:default][:data_dir]
    node[:redis][:instances][params[:name]][:data_dir] = ::File.join(node[:redis][:instances][:default][:data_dir], params[:name])
  end
  swap_file = begin; node[:redis][:instances][params[:name]][:vm][:swap_file]; rescue; nil; end
  if swap_file.nil? or swap_file == node[:redis][:instances][:default][:vm][:swap_file]
    node.default[:redis][:instances][params[:name]][:vm][:swap_file] = ::File.join(
      ::File.dirname(node[:redis][:instances][:default][:vm][:swap_file]), "swap_#{params[:name]}")
  end

  init_dir = value_for_platform([:debian, :ubuntu] => {:default => "/etc/init.d/"},
                              [:centos, :redhat] => {:default => "/etc/rc.d/init.d/"},
                              :default => "/etc/init.d/")

  unless params[:name] == "default"
    conf = ::Chef::Node::Attribute.new(
      ::Chef::Mixin::DeepMerge.merge(node.normal[:redis][:instances][:default].to_hash, node.normal[:redis][:instances][params[:name]].to_hash),
      ::Chef::Mixin::DeepMerge.merge(node.default[:redis][:instances][:default].to_hash, node.default[:redis][:instances][params[:name]].to_hash),
      ::Chef::Mixin::DeepMerge.merge(node.override[:redis][:instances][:default].to_hash, node.override[:redis][:instances][params[:name]].to_hash),
      {})
  else
    conf = node[:redis][:instances][:default]
  end

  directory node[:redis][:instances][params[:name]][:data_dir] do
    owner node[:redis][:user]
    mode "0750"
  end

  conf_vars = {:conf => conf, :instance_name => params[:name], :master => params[:master]}

  template ::File.join(node[:redis][:conf_dir], "#{instance_name}.conf") do
    source "redis.conf.erb"
    cookbook "redis"
    variables conf_vars
    mode "0644"
    notifies :restart, "service[#{instance_name}]"
  end

  runit_service instance_name do
    template_name "redis"
    cookbook "redis"
    options :user => node[:redis][:user],
      :config_file => ::File.join(node[:redis][:conf_dir], "#{instance_name}.conf")
  end

  service instance_name do
    supports :reload => false, :restart => true, :start => true, :stop => true
    action :start
  end
end
