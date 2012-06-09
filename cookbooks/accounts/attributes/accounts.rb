#
# Cookbook Name:: accounts
# Attributes:: accounts
#
# Copyright 2009, Alexander van Zoest
#
accounts Mash.new unless attribute?("accounts")
# global settings
accounts[:dir] = "/home" unless accounts.has_key?(:dir)
accounts[:cookbook] = "accounts" unless accounts.has_key?(:cookbook)
# default settings
accounts[:default] =  Mash.new unless attribute?("default")
accounts[:default][:shell] = "/bin/bash" unless accounts[:default].has_key?(:shell)
accounts[:default][:file_backup] = 2 unless accounts[:default].has_key?(:file_backup)
accounts[:default][:group] = "users" unless accounts[:default].has_key?(:group)
accounts[:default][:do_ssh] = false unless accounts[:default].has_key?(:do_ssh)
accounts[:default][:do_sudo] = false unless accounts[:default].has_key?(:do_sudo)
# sudo access management
accounts[:sudo] = Mash.new unless accounts.has_key?(:sudo)
unless accounts[:sudo].has_key?(:groups)
  accounts[:sudo][:groups] = Array.new
end
unless accounts[:sudo].has_key?(:users)
  accounts[:sudo][:users] = Array.new
end
