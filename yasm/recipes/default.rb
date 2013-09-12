#
# Cookbook Name:: yasm
# Recipe:: default
#
# Copyright 2012-2013, Escape Studios
#

case node[:yasm][:install_method]
    when :source
        include_recipe "yasm::source"
    when :package
        include_recipe "yasm::package"
end