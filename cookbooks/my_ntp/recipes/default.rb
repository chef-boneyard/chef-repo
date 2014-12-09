#
# Cookbook Name:: my_ntp
# Recipe:: default
#
# Copyright 2014, papi
#
# All rights reserved - Do Not Redistribute
#
 
include_recipe 'ntp-cookbook::ntpdate'

resources ("template[/etc/default/ntpdate]").cookbook "my_ntp"
  
