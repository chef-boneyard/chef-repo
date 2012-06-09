#
# Cookbook Name: accounts
# Definition: agroup
#
# Copyright 2009, Alexander van Zoest
#
define :agroup, :gid => nil, :sudo => false do

  # http://wiki.opscode.com/display/chef/Resources#Resources-Group
  group params[:name] do
     gid params[:gid]
  end

  if params[:sudo]
    unless node[:accounts].has_key?(:sudo)
      node[:accounts][:sudo] = Mash.new
    end
    unless node[:accounts][:sudo].has_key?(:groups)
       node[:accounts][:sudo][:groups] = Array.new
    end
    node[:accounts][:sudo][:groups] |= [params[:name]]
  end

end
