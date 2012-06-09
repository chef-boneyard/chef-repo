# Cookbook Name:: daemons
# Recipe:: default
#
# Copyright 2011, CyByL
# All rights reserved - Do Not Redistribute
#
include_recipe 'runit'

if node[:daemons]
  node[:daemons].each do |name,config|
    runit_service name do
      template_name "daemon"
      cookbook "daemons"
      options config
    end
    service "daemon-#{name}" do
        action [:enable, :start]
    end
  end
end

