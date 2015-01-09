Description
===========

Installs Ruby and related packages.

Requirements
============

## Platform

Tested on Ubuntu 10.04. Debian and Gentoo should also work fully.
CentOS, Red Hat, Fedora and Arch are partially supported.

Attributes
==========

* `node[:languages][:ruby][:default_version]` - The Ruby version to install
  with the ruby recipe and create symlinks for with the symlinks
  recipe.

Usage
=====

Previous versions of this cookbook gave you no control over which
version of Ruby would be installed. We are now in the middle of an
awkward period where you are equally likely to want 1.8 or 1.9. You
may even want both. This is now catered for. To install specific
versions side-by-side, use the 1.8, 1.9 or 1.9.1 recipes. The ruby
recipe will install the version specified by
`node[:languages][:ruby][:default_version]`. If you want to do something
other than install these packages, the `ruby_packages` definition is
provided as a wrapper around the package resource. Just specify the
version number.

For example, to use the default recipe in a role named "base", use
'ruby' in the run list and set the
`node[:languages[:ruby][:default_version]` attribute:

    {
      "name": "base",
      "description": "Base role is applied to all systems",
      "json_class": "Chef::Role",
      "default_attributes": {
      },
      "override_attributes": {
        "languages": {
          "ruby": {
            "default_version": "1.8"
          }
        }
      },
      "chef_type": "role",
      "run_list": [
        "recipe[ruby]"
      ]
    }

Many scripts, including those provided by Rails, don't ask for a
particular version of Ruby such as "ruby1.8" and simply look for
"ruby" instead. Sometimes a symlink is provided and sometimes the
executable is simply called "ruby" in the first place but generally
speaking, it is difficult to predict this behaviour, especially when
Ruby Gems is thrown into the mix. The symlinks recipe seeks to relieve
you of this headache by creating symlinks for the common executables
pointing to the Ruby version specified by
`node[:languages][:ruby][:default_version]`. This is also available as a
definition called +ruby_symlinks+, which is a wrapper around the link
resource. As before, just specify the version number. Non-symlinks
will not be overwritten unless you set force to true. You can also set
a path other than /usr/bin if necessary.

*IMPORTANT!* Only Ubuntu, Debian and Gentoo support installing a
 specific Ruby version at all. yum-based distributions install 1.8 by
 default but require you to give the full package version otherwise.
 Maybe some magic could be added to Chef? Arch installs 1.9.2 by
 default but 1.8 is only available from AUR. Additionally, Ubuntu and
 Debian group 1.9.2 with 1.9.1 while Gentoo lumps all 1.9 releases
 together.

License and Author
==================

- Author: Joshua Timberman (<joshua@opscode.com>)
- James Le Cuirot (<developers@findsyou.com>)

- Copyright: 2009-2010, Opscode, Inc
- Copyright: 2010, FindsYou Limited

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
