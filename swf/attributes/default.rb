#
# Cookbook Name:: core_mla
# Attributes:: default
#


default[:swf][:git_repository] = "git@github.com:YesVideo/SWFVideoProcessor.git"

# JW 07-06-11: Hash of commit or a HEAD should be used - not a tag. Sync action of Git
# provider will always attempt to update the git clone if a tag is used.
default[:swf][:git_revision]   = "HEAD"
