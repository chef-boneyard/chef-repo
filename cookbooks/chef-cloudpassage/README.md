Description
===========

This cookbook provides an easy way to install CloudPassage/Halo.

More information?
http://cloudpassage.com/features/

Requirements
============

## Cookbooks:

This cookbook doesn't have direct dependencies on other cookbooks.

## Platforms:

* Debian
* Ubuntu
* RHEL
* CentOS
* Fedora
* Scientific
* Amazon

Attributes
==========

* `node['cloudpassage']['repository_key']` - The CloudPassage repository key, defaults to "4e750694a24da434d6fdf0bf271ad361"
* `node['cloudpassage']['license_key']` - Your CloudPassage license key.

Usage
=====

1) include `recipe[cloudpassage]` in a run list
2)
    change the `node['cloudpassage']['license_key']` attribute to your CloudPassage license key
    --- OR ---
    override the attribute on a higher level (http://wiki.opscode.com/display/chef/Attributes#Attributes-AttributesPrecedence)

References
==========

* [CloudPassage home page] (http://cloudpassage.com/)
* [CloudPassage features] (http://cloudpassage.com/features/)

License and Authors
===================

Author: David Joos <david@escapestudios.com>
Author: Escape Studios Development <dev@escapestudios.com>
Copyright: 2012-2013, Escape Studios

Unless otherwise noted, all files are released under the MIT license,
possible exceptions will contain licensing information in them.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.