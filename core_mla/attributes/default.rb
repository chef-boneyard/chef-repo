#
# Cookbook Name:: core_mla
# Attributes:: default
#


default[:core_mla][:git_repository] = "git@github.com:YesVideo/CoreMLA.git"

# JW 07-06-11: Hash of commit or a HEAD should be used - not a tag. Sync action of Git
# provider will always attempt to update the git clone if a tag is used.
default[:core_mla][:git_revision]   = "HEAD"
