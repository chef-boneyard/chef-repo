maintainer       "Sander van Zoest"
maintainer_email "sander@vanzoest.com"
license          "Apache 2.0"
description      "System Accounts management"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.1"
replaces         "sudo"
conflicts        "sudo"
%w{redhat centos debian ubuntu}.each do |os|
  supports os
end
recipe           "accounts", "Generic Account Setup, users can be added via definition"
recipe           "accounts::sysadmins", "Shortcut for loading all system administrator accounts"
recipe           "accounts::apps", "Shortcut for Application Specific Role accounts"
recipe           "accounts::staff", "Shortcut for loading all staff accounts"
provides         "account(:user, :group, :ssh, :sudo)"
provides         "agroup(:group, :sudo)"

attribute "accounts",
  :display_name => "Accounts Hash",
  :description => "Hash of Accounts attributes",
  :type => "hash"

attribute "accounts/dir",
  :display_name => "Accounts Directory",
  :description => "Default Home Directory for Accounts",
  :default => "/home"

attribute "accounts/cookbook",
  :display_name => "cookbook that contains the per account files",
  :description => "The name of the cookbook where the files for each account are stored",
  :default => "accounts"

attribute "accounts/default",
  :display_name => "Accounts Defaults",
  :description => "Default Settings",
  :type => "hash"

attribute "accounts/default/shell",
  :display_name => "Account Default Shell",
  :description => "Path to shell set during account creation when none is explicitly provided",
  :default => "/bin/bash"

attribute "accounts/default/group",
  :display_name => "Account Default Group",
  :description => "Default unix group to use when none is explicitly provided",
  :default => "users"

attribute "accounts/default/do_ssh",
  :display_name => "Account Default SSH setting",
  :description => "By default manage SSH files",
  :default => "true"

attribute "accounts/default/do_sudo",
  :display_name => "Account Default sudo setting",
  :description => "By default enable sudo access",
  :default => "false"

attribute "accounts/default/file_backup",
  :display_name => "Account File backups",
  :description => "Number of files to keep as backup when copying files in place",
  :default => "2"

attribute "accounts/sudo",
  :display_name => "Sudo Account Management",
  :description => "Hash of attributes",
  :type => "hash"

attribute "accounts/sudo/groups",
  :display_name => "Sudo Groups",
  :description => "Groups who are allowed sudo ALL",
  :type => "array",
  :default => ""
   
attribute "accounts/sudo/users",
  :display_name => "Sudo users",
  :description => "Users who are allowed to sudo ALL",
  :type => "array",
  :default => ""
