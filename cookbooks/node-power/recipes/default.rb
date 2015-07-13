#
# Cookbook Name:: node-power
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
# Author: Dmitry Duplyakin (dmitry.duplyakin@colorado.edu)

# Only run on ARM nodes
if node['kernel']['machine'] != 'aarch64'
  Chef::Log.error("Node's architecture '#{node['kernel']['machine']}' does not match 'aarch64'. This recipe is designed to run only on ARM nodes. Exiting")
  return
end

# Check if the kernel is already updated
if node['kernel']['release'] == '3.13.11-ckt20'
  Chef::Log.info("Kernel has been patched already (version 3.13.11-ckt20). Nothing to do. Exiting")
  return
end

patched_kernel_url = "https://s3-us-west-2.amazonaws.com/dmdu-cloudlab/kernel-3.13.11-ckt20.tar.gz"
patched_kernel_tar = "/tmp/kernel-3.13.11-ckt20.tar.gz"

# download the tarball (or use exisiting one if the checksum matches)
remote_file patched_kernel_tar do
  source patched_kernel_url 
  # 07/13/15: Latest tarball, which includes boot.scr
  checksum '8da85617f34e1abe21e51b03a5e5da0815338777cf6dfe3db58c55cde47f4a25'
end

# make a backup copy of /boot
execute "cp -r boot boot.BACKUP" do
  cwd '/'
  not_if { ::File.exists?('/boot.BACKUP') }
end

# extract the tarball into /boot
execute "tar xf #{patched_kernel_tar}" do
  cwd '/boot'
end

# Need to reboot the node in order to boot the patched kernel
execute "reboot" do
end
