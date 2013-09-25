authorized_keys Cookbook
=====================
This is the default development template for all boxes spun up for meniscus development environments.

Requirements
------------
Chef 10.18.2 

Platform
--------
- Ubuntu

Tested on:
- Ubuntu 12.04

Attributes
----------
* `default[:authorized_keys][:authorized_keys]` - `String` - The authorized keys for access to nodes
* `default[:authorized_keys][:databag_name]` - `String` - Chef databag name
* `default[:authorized_keys][:databag_item]` - `String` - Chef databag item

Usage
-----
#### dev-template::default

Just include `authorized_keys` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[authorized_keys]"
  ]
}
```

License and Authors
-------------------
- Author:: Steven Gonzales (steven.gonzales@RACKSPACE.COM)

```text
Copyright:: 2009-2013 Opscode, Inc

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
