#
# Cookbook Name:: my_ntp
# Recipe:: default
#
# Copyright 2014, papi
#
# All rights reserved - Do Not Redistribute
#
 
include_recipe 'ntp-cookbook'
begin
 my_res = resources ("template[/etc/default/ntpdate]")
 my_res.cookbook "my_ntp"

  rescue Chef::Exceptions::ResourceNotFound
    Chef::Log.warn "could not find template to override!"
  
end
