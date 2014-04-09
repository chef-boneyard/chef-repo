# chef-percona

[![Build Status](http://img.shields.io/travis-ci/phlipper/chef-percona.png)](https://travis-ci.org/phlipper/chef-percona)
[![Code Climate](https://codeclimate.com/github/phlipper/chef-percona.png)](https://codeclimate.com/github/phlipper/chef-percona)

## Description

Installs the [Percona
MySQL](http://www.percona.com/software/percona-server) client and/or
server components. (We are attempting to leverage the official Opscode
MySQL cookbook as much as possible.)

Optionally installs:

* [XtraBackup](http://www.percona.com/software/percona-xtrabackup/) hot backup software
* [Percona Toolkit](http://www.percona.com/software/percona-toolkit/) advanced command-line tools
* [XtraDB
Cluster](http://www.percona.com/software/percona-xtradb-cluster/) high
availability and high scalability solution for MySQL. {DEPRECATED}
* [Percona Monitoring Plugins](http://www.percona.com/software/percona-monitoring-plugins) various Nagios plugins for monitoring MySQL

## Requirements

### Supported Platforms

We provide an expanding set of tests against the following 64-bit platforms:

* Ubuntu Precise 12.04 LTS
* Centos 6.4

Although we don't test against all possible platform verions, we expect
the following to be supported. Please submit an issue if this is not the
cause, and we'll make reasonable efforts to improve support:

* Ubuntu
* Debian
* Amazon Linux AMI
* CentOS
* Red Hat
* Scientific
* Fedora

### Cookbooks

* [apt](http://community.opscode.com/cookbooks/apt) Opscode LWRP Cookbook
* [openssl](http://community.opscode.com/cookbooks/openssl) Opscode Cookbook
* [yum](http://community.opscode.com/cookbooks/yum) Opscode LWRP Cookbook
* [mysql](http://community.opscode.com/cookbooks/mysql) Opscode Cookbook

### Chef

We aim to test the most recent releases of Chef 10 and 11. You can view
the [currently tested versions](https://github.com/phlipper/chef-percona/blob/master/.travis.yml#L12-L13).
(Feel free to submit a pull request if they're out of date!)


## Recipes

* `percona` - The default no-op recipe.
* `percona::package_repo` - Sets up the package repository and installs common packages.
* `percona::client` - Installs the Percona MySQL client libraries.
* `percona::server` - Installs and configures the Percona MySQL server daemon.
* `percona::backup` - Installs and configures the Percona XtraBackup hot backup software.
* `percona::toolkit` - Installs the Percona Toolkit software
* `percona::cluster` - *{DEPRECATED}* Installs the Percona XtraDB Cluster server components
* `percona::configure_server` - Used internally to manage the server configuration.
* `percona::replication` - Used internally to grant permissions for replication.
* `percona::access_grants` - Used internally to grant permissions for recipes.
* `percona::monitoring` - Installs Percona monitoring plugins for Nagios

## Usage

This cookbook installs the Percona MySQL components if not present, and pulls updates if they are installed on the system.

### Encrypted Passwords

This cookbook requires [Encrypted Data Bags](http://wiki.opscode.com/display/chef/Encrypted+Data+Bags). If you forget to use them or do not use a node attribute to overwrite them empty passwords will be used.

To use encrypted passwords, you must create an encrypted data bag. This cookbook assumes a data bag named `passwords`, but you can override the name using the `node[:percona][:encrypted_data_bag]` attribute.

This cookbook expects a `mysql` item  and a `system` item. Please refer to the official documentation on how to get this setup. It actually uses a MySQL example so it can be mostly copied. Ensure you cover the data bag items as described below.

### Skip passwords
Set the `["percona"]["skip_passwords"]` attribute to skip setting up passwords. Removes the need for the encrypted data bag if using chef-solo. Is useful for setting up development and ci environments where you just want to use the root user with no password. If you are doing this you may want to set `[:percona][:server][:debian_username]` to be `"root"` also.

#### mysql item

The mysql item should contain entries for root, backup, and replication. If no value is found, the cookbook will fall back to the default non-encrypted password.

#### system item

The "system" item should contain an entry for the debian system user as specified in the `node[:percona][:server][:debian_username]` attribute. If no such entry is found, the cookbook will fall back to the default non-encrypted password.

Example: "passwords" data bag - this example assumes that `node[:percona][:server][:debian_username] = spud`

```javascript
{
  "mysql" :
  {
    "root" : "trywgFA6R70NO28PNhMpGhEvKBZuxouemnbnAUQsUyo=\n"
    "backup" : "eqoiudfj098389fjadfkadf=\n"
    "replication" : "qwo0fj0213fm9020fm2023fjsld=\n"
  },
  "system" :
  {
    "spud" : "dwoifm2340f024jfadgfu243hf2=\n"
  }
}
```

Above shows the encrypted password in the data bag. Check out the `encrypted_data_bag_secret` setting in `knife.rb` to setup your data bag secret during bootstrapping.

## Attributes

```ruby
# Always restart percona on configuration changes
default["percona"]["auto_restart"] = true

case node["platform_family"]
when "debian"
  default["percona"]["server"]["socket"]                        = "/var/run/mysqld/mysqld.sock"
  default["percona"]["server"]["default_storage_engine"]        = "InnoDB"
  default["percona"]["server"]["includedir"]                    = "/etc/mysql/conf.d/"
  default["percona"]["server"]["pidfile"]                       = "/var/run/mysqld/mysqld.pid"
  default["percona"]["server"]["package"]                       = "percona-server-server-5.5"
when "rhel"
  default["percona"]["server"]["socket"]                        = "/var/lib/mysql/mysql.sock"
  default["percona"]["server"]["default_storage_engine"]        = "innodb"
  default["percona"]["server"]["includedir"]                    = ""
  default["percona"]["server"]["pidfile"]                       = "/var/lib/mysql/mysqld.pid"
  default["percona"]["server"]["package"]                       = "Percona-Server-server-55"
  default["percona"]["server"]["shared_pkg"]                    = "Percona-Server-shared-55"
end

# Cookbook Settings
default["percona"]["main_config_file"]                          = "/etc/my.cnf"
default["percona"]["keyserver"]                                 = "keys.gnupg.net"
default["percona"]["encrypted_data_bag"]                        = "passwords"

# Start percona server on boot
default["percona"]["server"]["enable"]                          = true

# Basic Settings
default["percona"]["server"]["role"]                            = "standalone"
default["percona"]["server"]["username"]                        = "mysql"
default["percona"]["server"]["datadir"]                         = "/var/lib/mysql"
default["percona"]["server"]["tmpdir"]                          = "/tmp"
default["percona"]["server"]["debian_username"]                 = "debian-sys-maint"
default["percona"]["server"]["nice"]                            = 0
default["percona"]["server"]["open_files_limit"]                = 16384
default["percona"]["server"]["hostname"]                        = "localhost"
default["percona"]["server"]["basedir"]                         = "/usr"
default["percona"]["server"]["port"]                            = 3306
default["percona"]["server"]["character_set"]                   = "utf8"
default["percona"]["server"]["collation"]                       = "utf8_unicode_ci"
default["percona"]["server"]["language"]                        = "/usr/share/mysql/english"
default["percona"]["server"]["skip_name_resolve"]               = false
default["percona"]["server"]["skip_external_locking"]           = true
default["percona"]["server"]["net_read_timeout"]                = 120
default["percona"]["server"]["connect_timeout"]                 = 10
default["percona"]["server"]["old_passwords"]                   = 0
default["percona"]["server"]["bind_address"]                    = "127.0.0.1"
%w[debian_password root_password].each do |attribute|
  next if defined?(node["percona"]["server"][attribute])
  default["percona"]["server"][attribute]                       = secure_password
end

# Fine Tuning
default["percona"]["server"]["key_buffer"]                      = "16M"
default["percona"]["server"]["max_allowed_packet"]              = "64M"
default["percona"]["server"]["thread_stack"]                    = "192K"
default["percona"]["server"]["query_alloc_block_size"]          = "16K"
default["percona"]["server"]["memlock"]                         = false
default["percona"]["server"]["transaction_isolation"]           = "REPEATABLE-READ"
default["percona"]["server"]["tmp_table_size"]                  = "64M"
default["percona"]["server"]["max_heap_table_size"]             = "64M"
default["percona"]["server"]["sort_buffer_size"]                = "8M"
default["percona"]["server"]["join_buffer_size"]                = "8M"
default["percona"]["server"]["thread_cache_size"]               = 16
default["percona"]["server"]["back_log"]                        = 50
default["percona"]["server"]["max_connections"]                 = 30
default["percona"]["server"]["max_connect_errors"]              = 9999999
default["percona"]["server"]["table_cache"]                     = 8192
default["percona"]["server"]["group_concat_max_len"]            = 4096

# Query Cache Configuration
default["percona"]["server"]["query_cache_size"]                = "64M"
default["percona"]["server"]["query_cache_limit"]               = "2M"

# Logging and Replication
default["percona"]["server"]["sync_binlog"]                     = 1
default["percona"]["server"]["slow_query_log"]                  = 1
default["percona"]["server"]["slow_query_log_file"]             = "/var/log/mysql/mysql-slow.log"
default["percona"]["server"]["long_query_time"]                 = 2
default["percona"]["server"]["server_id"]                       = 1
default["percona"]["server"]["binlog_do_db"]                    = []
default["percona"]["server"]["expire_logs_days"]                = 10
default["percona"]["server"]["max_binlog_size"]                 = "100M"
default["percona"]["server"]["binlog_cache_size"]               = "1M"
default["percona"]["server"]["binlog_format"]                   = "MIXED"
default["percona"]["server"]["log_bin"]                         = "master-bin"
default["percona"]["server"]["relay_log"]                       = "slave-relay-bin"
default["percona"]["server"]["log_slave_updates"]               = false
default["percona"]["server"]["log_warnings"]                    = true
default["percona"]["server"]["log_long_format"]                 = false
default["percona"]["server"]["bulk_insert_buffer_size"]         = "64M"

# MyISAM Specific
default["percona"]["server"]["myisam_recover"]                  = "BACKUP"
default["percona"]["server"]["myisam_sort_buffer_size"]         = "128M"
default["percona"]["server"]["myisam_max_sort_file_size"]       = "10G"
default["percona"]["server"]["myisam_repair_threads"]           = 1

# InnoDB Specific
default["percona"]["server"]["skip_innodb"]                     = false
default["percona"]["server"]["innodb_additional_mem_pool_size"] = "32M"
default["percona"]["server"]["innodb_buffer_pool_size"]         = "128M"
default["percona"]["server"]["innodb_data_file_path"]           = "ibdata1:10M:autoextend"
default["percona"]["server"]["innodb_file_per_table"]           = true
default["percona"]["server"]["innodb_data_home_dir"]            = ""
default["percona"]["server"]["innodb_thread_concurrency"]       = 16
default["percona"]["server"]["innodb_flush_log_at_trx_commit"]  = 1
default["percona"]["server"]["innodb_fast_shutdown"]            = false
default["percona"]["server"]["innodb_log_buffer_size"]          = "64M"
default["percona"]["server"]["innodb_log_file_size"]            = "5M"
default["percona"]["server"]["innodb_log_files_in_group"]       = 2
default["percona"]["server"]["innodb_max_dirty_pages_pct"]      = 80
default["percona"]["server"]["innodb_flush_method"]             = "O_DIRECT"
default["percona"]["server"]["innodb_lock_wait_timeout"]        = 120

# Replication Settings
default["percona"]["server"]["replication"]["read_only"]        = false
default["percona"]["server"]["replication"]["host"]             = ""
default["percona"]["server"]["replication"]["username"]         = ""
default["percona"]["server"]["replication"]["password"]         = ""
default["percona"]["server"]["replication"]["port"]             = 3306

# XtraBackup Settings
default["percona"]["backup"]["configure"]                       = false
default["percona"]["backup"]["username"]                        = "backup"
unless defined?(node["percona"]["backup"]["password"])
  default["percona"]["backup"]["password"]                      = secure_password
end

# XtraDB Cluster Settings
default["percona"]["cluster"]["binlog_format"]                  = "ROW"
default["percona"]["cluster"]["wsrep_provider"]                 = "/usr/lib64/libgalera_smm.so"
default["percona"]["cluster"]["wsrep_cluster_address"]          = ""
default["percona"]["cluster"]["wsrep_slave_threads"]            = 2
default["percona"]["cluster"]["wsrep_cluster_name"]             = ""
default["percona"]["cluster"]["wsrep_sst_method"]               = "rsync"
default["percona"]["cluster"]["wsrep_node_name"]                = ""
default["percona"]["cluster"]["innodb_locks_unsafe_for_binlog"] = 1
default["percona"]["cluster"]["innodb_autoinc_lock_mode"]       = 2
```

### Monitoring.rb

```ruby
default['percona']['plugins_url'] = "http://www.percona.com/downloads/percona-monitoring-plugins/"
default['percona']['plugins_version'] = "1.0.2"
default['percona']['plugins_sha'] = "da84cfe89637292da15ddb1e66f67ad9703fa21392d8d49e664ad08f7aa45585"
default['percona']['plugins_path'] = "/opt/pmp"
```

## Explicit my.cnf templating

In some situation it is preferable to explicitly define the attributes needed in a `my.cnf` file. This is enabled by adding categories to the `node[:percona][:conf]` attributes. All keys found in the `node[:percona][:conf]` map will represent categories in the `my.cnf` file. Each category contains a map of attributes that will be written to the `my.cnf` file for that category. See the example for more details.

### Example:

```ruby
node["percona"]["conf"]["mysqld"]["slow_query_log_file"] = "/var/lib/mysql/data/mysql-slow.log"
```

This configuration would write the `mysqld` category to the `my.cnf` file and have an attribute `slow_query_log_file` whose value would be `/var/lib/mysql/data/mysql-slow.log`.

### Example output (my.cnf):

```ini
[mysqld]
slow_query_log_file = /var/lib/mysql/data/mysql-slow.log
```

## Dynamically setting the bind address

There's a special attribute `node['percona']['server']['bind_to']` that allows you to dynamically set the bind address. This attribute accepts the values `'public_ip'`, `'private_ip'`, `'loopback'`, or and interface name like `'eth0'`. Based on this, the recipe will find a corresponding ipv4 address, and override the `node['percona']['server']['bind_address']` attribute.

## Goals

In no particular order:

* Be the most flexible way to setup a MySQL distribution through Chef
    * Support for Chef Solo
    * Support for Chef Server
* Leverage to official Opscode MySQL cookbook as much as possible.
* Support the following common database infrastructures:
    * Single server instance
    * Traditional Master/Slave replication
    * Multi-master cluster replication {DEPRECATED}
* Support the most recent Chef 10 & 11 runtime environments
* Be the easiest way to setup a MySQL distribution through Chef


## TODO

* Fully support all of the standard Chef-supported distributions


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Contributors

Many thanks go to the following [contributors](https://github.com/phlipper/chef-percona/graphs/contributors) who have helped to make this cookbook even better:

* **[@jagcrete](https://github.com/jagcrete)**
    * configurable keyserver
    * encrypted password data bag
    * custom `my.cnf` file
* **[@pwelch](https://github.com/pwelch)**
    * ensure cookbook dependencies are loaded
    * [Foodcritic](http://acrmp.github.com/foodcritic/) compliance updates
    * various minor patches and updates
* **[@masv](https://github.com/masv)**
    * compatibility updates for 5.5
* **[@stottsan](https://github.com/stottsan)**
    * config cleanup to prevent service restarts on chef run
* **[@abecciu](https://github.com/abecciu)**
    * auto-generate secure passwords by default
    * add ability to dynamically set the bind address
    * add support for `main_config_file` attribute
* **[@patcon](https://github.com/patcon)**
    * add `yum` support for `centos`, `amazon`, `scientific`, `fedora`, and `redhat` distributions
* **[@psi](https://github.com/psi)**
    * fixes required for RedHat platforms
* **[@TheSerapher](https://github.com/TheSerapher)**
    * improvements for master/slave replication setup
    * updates and clarifications to the README
    * add attribute to control server restart on config changes
* **[@bensomers](https://github.com/bensomers)**
    * minor fixes to `replication.sql`
    * fix a very dangerous bug around binlog-do-db setting for slave servers
    * fix slow query log setting for 5.5
* **[@tdg5](https://github.com/tdg5)**
    * avoid use of `set_unless` for chef-solo, workaround for CHEF-2945
* **[@gpendler](https://github.com/gpendler)**
    * avoid re-installation of packages RedHat platforms
* **[@vinu](https://github.com/vinu)**
    * pin the percona apt repo with high priority
* **[@ckuttruff](https://github.com/ckuttruff)**
    * improve security on debian-based systems by changing config file permissions
    * don't pass mysql root password in plaintext commands
    * fix issue with -p flag when setting initial password
* **[@srodrig0209](https://github.com/srodrig0209)**
    * add the `monitoring` recipe
* **[@jesseadams](https://github.com/jesseadams)**
    * fixes for custom datadir setting use case
* **[@see0](https://github.com/see0)**
    * fix incorrect root password reference
* **[@baldur](https://github.com/baldur)**
    * _(honorable mention)_ fix incorrect root password reference
    * fix typo in attribute for server username
* **[@chrisroberts](https://github.com/chrisroberts)**
    * _(honorable mention)_ fix issue with -p flag when setting initial password
* **[@aaronjensen](https://github.com/aaronjensen)**
    * allow server to not be started on startup
* **[@pioneerit](https://github.com/pioneerit)**
    * add sections to `.my.cnf` for `mysqladmin` and `mysqldump`
* **[@AndreyChernyh](https://github.com/AndreyChernyh)**
    * use resources helper to support newer chef versions
* **[@avit](https://github.com/avit)**
    * add default utf8 character set option
* **[@alexzorin](https://github.com/alexzorin)**
    * add support for `skip-name-resolve` option
* **[@jyotty](https://github.com/jyotty)**
    * specify `binlog_format` in master and slave roles
* **[@adamdunkley](https://github.com/adamdunkley)**
    * fix `table_cache` variable for mysql versions 5.6 and above
    * remove unnecessary rewind, perform it directly
* **[@freerobby](https://github.com/freerobby)**
    * add requirements to `Berksfile`
    * more flexible apt dependency version to minimize conflicts
* **[@spovich](https://github.com/spovich)**
    * disable `old_passwords` support by default
    * force version 5.5 on Debian family to maintain consistency with RHEL family
* **[@v1nc3ntlaw](https://github.com/v1nc3ntlaw)**
    * add attribute `innodb_file_format`
    * add attribute `ignore_db` for slave template
* **[@joegaudet](https://github.com/joegaudet)**
    * add attribute `group_concat_max_len`
* **[@mikesmullin](https://github.com/mikesmullin)**
    * accumulating patches from multiple sources
    * tempdir fixes
* **[@totally](https://github.com/totally)**
    * support `yum` cookbook v3.0
    * use attributes for package names
* **[@sapunoff](https://github.com/sapunoff)**
    * initial implementation of using attributes for package names
* **[@errm](https://github.com/errm)**
    * add attribute `skip_passwords`
* **[@ewr](https://github.com/ewr)**
    * fix mysql calls when there is no root password
* **[@jharley](https://github.com/jharley)**
    * make `connect_timeout` configurable
* **[@achied](https://github.com/achied)**
    * fix setting passwords if attribute not defined
* **[@akshah123](https://github.com/akshah123)**
    * force client packages to install version 5.5


## License

Author:: Phil Cohen (<github@phlippers.net>) [![endorse](http://api.coderwall.com/phlipper/endorsecount.png)](http://coderwall.com/phlipper) [![Gittip](http://img.shields.io/gittip/phlipper.png)](https://www.gittip.com/phlipper/)

Copyright:: 2011-2013, Phil Cohen

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.


[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/phlipper/chef-percona/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

