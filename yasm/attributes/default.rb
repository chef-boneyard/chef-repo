#
# Cookbook Name:: yasm
# Attributes:: default
#
# Copyright 2012-2013, Escape Studios
#

default[:yasm][:install_method] = :package
default[:yasm][:prefix] = "/usr/local"
default[:yasm][:git_repository] = "git://github.com/yasm/yasm.git"
default[:yasm][:git_revision] = "HEAD"
default[:yasm][:compile_flags] = []