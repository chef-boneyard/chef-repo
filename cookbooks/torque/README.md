torque Cookbook
===============

This cookbook installs and configures a torque (PBS) cluster.

Requirements
------------
### Platforms
The recipes work on the following tested platforms:

- Ubuntu 12.04, Ubuntu 14.04
- CentOS 6.5

It may work on other platforms or versions of the above platforms with or without modification.

### Cookbooks
The following Opscode cookbook are dependencies:

- yum-epel (>= 0.3.6)

Attributes
----------
All of the attributes has default values.


`default['torque']['etc_dir']` - Location of "server_name" file in all distros. Mom config directory location in Red Hat famaily. 
`default['torque']['var_dir']` - Torque service location.  
`default['torque']['publickey']` - Torque head stores the public key of the service user in this attribute.
`default['torque']['user']` - Torque username. Root is not allowed.

# PBS queue parameters - for the details, please contact the torque documantation at "http://docs.adaptivecomputing.com".
`default['torque']['manager_host']`
`default['torque']['acl_hosts']`
`default['torque']['server_scheduling']`
`default['torque']['keep_completed']`
`default['torque']['mom_job_sync']`
`default['torque']['queue']`
`default['torque']['queue_type']`
`default['torque']['started']`
`default['torque']['enabled']`
`default['torque']['walltime']`
`default['torque']['walltime']`
`default['torque']['default_queue']`
`default['torque']['auto_node_np']`


Usage
-----
#### torque::default
Default recipe installs the torque commons and create a user. 
Torque head and compute node recipe includes the default one 
so it should not be used alone.

#### torque::head_node
Head_node recipe installs the torque server and client packages and 
configures the job queue. It generates a key pair for the torque
user and publishes the public key. It collects the compute nodes 
in the __same__ environment and joins them to the cluster. 
Importan: If a compute node appears or leaves, the chef-client sould be
issued again.   

#### torque::compute_node
Compute_node recipe installs the torque mom package, prepare connection
to the torque cluster and set up the torque user. 
Important: It requires a head node in the same environment.

License & Authors
-----------------
- Author:: Sandor Acs (<sandoracs1986@gmail.com>)
- Author:: Mark Gergely (<markgergely@me.com>)

```text
Copyright 2014, MTA SZTAKI

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