#
# Cookbook Name:: yasm
# Attributes:: default
#
# Copyright 2012-2013, Escape Studios
#

default[:yasm][:install_method] = :source
default[:yasm][:prefix] = "/usr/local"
default[:yasm][:git_repository] = "git://github.com/yasm/yasm.git"
default[:yasm][:git_revision] = "0f5e8ebdb5a273d8fd61e00e90d0c9778b7814cf" #version 1.2.0
default[:yasm][:compile_flags] = []