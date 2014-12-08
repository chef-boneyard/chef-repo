Changes
=======

# 2.0.0 / 2014-08-22

* **BREAKING CHANGE**: Datadog Agent 5.0.0 Release Edition

  With the release of Datadog Agent 5.x, all Python dependencies are now bundled, and extensions for monitoring are no
  longer needed. Integration-specific recipes no longer install any packages, so if you are using a version older than
  5.x, you may have to install these yourself. This greatly simplifies deployment of all components for monitoring.
  See commit b77582122f3db774a838f90907b421e544dd099c for the exact package resources that have been removed.
  Affected recipes:

  - hdfs
  - memcache
  - mongodb
  - mysql
  - postgres
  - redisdb

* **BREAKING CHANGE**: Removed chef_gem support for Chef versions pre 0.10.9.

  We haven't supported this version of Chef in some time, so it's unlikely that you will be affected at all.
  Just in case, please review what versions of Chef you have installed, and use an older version of this cookbook until
  you can upgrade them.

* [OPTIMIZE] Update repository recipe to choose correct arch, [@remh][]
* [OPTIMIZE] Remove conditional python dep for Ubuntu 11.04, [@miketheman][]
* [OPTIMIZE] Remove extra `apt-get` call during Agent recipe run, [@miketheman][]
* [FEATURE] Add `kafka` monitoring recipe & tests, [#113][] [@qqfr2507][]
* [FEATURE] Allow database name to be passed into postgres template, [@miketheman][]
* [MISC] Many updates to testing suite. Faster style, better specs. [@miketheman][]

# 1.2.0 / 2014-03-24

* [FEATURE] Add `relations` parameter to Postgres check config, [#97][] [@miketheman][]
* [FEATURE] Add `sock` parameter to MySQL check configuration, [#105][] [@thisismana][]
* [FEATURE] Add more parameters to the haproxy templte to collect status metrics, [#103][] [@evan2645][] & [@miketheman][]
* [FEATURE] `datadog::mongo` recipe now installs `pymongo` and prerequisites, [#81][] [@dwradcliffe][]
* [FEATURE] Allow attribute control over whether to allow the local Agent to handle non-local traffic, [#100][] [@coosh][]
* [FEATURE] Allow attribute control over whether the Chef Handler is activated, [#95][] [@jedi4ever][], [@miketheman][]
* [FEATURE] Allow attribute control over whether Agent should be running, [#94][] [@jedi4ever][], [@miketheman][]
* [FEATURE] Reintroduce attribute config for dogstatsd daemon, [#90][] [@jedi4ever][], [@miketheman][]
* [FEATURE] Allow jmx template to accept arbitrary `key, value` statements, [#93][] [@clofresh][]
* [FEATURE] Allow cassandra/zookeeper templates to accept arbitrary `key, value` statements, [@miketheman][]
* [FEATURE] Add name param to varnish recipe, [#86][] [@clofresh][]
* [FEATURE] Allow attribute-driven settings for web proxy, [#82][]  [@antonio-osorio][]
* [FEATURE] Allow override of Agent config for hostname via attribute, [#76][] [@ryandjurovich][]
* [FEATURE] Allow for non-conf.d integrations to be set via attributes, [#66][] [@babbottscott][]
* [FEATURE] added hdfs recipe and template, [#77][] [@phlipper][]
* [FEATURE] added zookeeper recipe and template, [#74][] [@phlipper][]
* [BUGFIX] Warn user when more than one `network` instance is defined, [#98][] [@miketheman][]
* [BUGFIX] Properly indent jmx template, [#88][] [@flah00][]
* [BUGFIX] Handle unrecognized Python version strings in a better fashion, [#79][] [#80][] [#84][], [@jtimberman][], [@schisamo][], [@miketheman][]
* [BUGFIX] Set gpgcheck to false for `yum` repo if it exists, [#89][] [@alexism][], [#101][] [@nkts][]
* [MISC] Inline doc for postgres recipe, [#83][] [@timusg][]


# 1.1.1 / 2013-10-17

* [FEATURE] added rabbitmq recipe and template, [@miketheman][]
* [BUGFIX] memcache dependencies and template, [#67][] [@elijahandrews][]
* [BUGFIX] redis python client check was not properly checking the default version, [@remh][]
* [MISC] tailor 1.3.1 caught some cosmetic issue, [@alq][]

# 1.1.0 / 2013-08-20

* [FEATURE] Parameterize chef-handler-datadog Gem version, [#60][] [@mfischer-zd][]
* [FEATURE] Allow control of `network.yaml` via attributes, [#63][] [@JoeDeVries][]
* [FEATURE] Use Python version from Ohai to determine packages to install, [#65][] [@elijahandrews][]
* [BUGFIX] redisdb default port in template should be 6379, [#59][] [@miketheman][]
* [BUGFIX] templates creating empty `tags` in config when unspecified for multiple integrations [#61][] [@alq][]
* [MISC] updated tests [@elijahandrews][], [@miketheman][]
* [MISC] correct the riak integration example, [@miketheman][]
* [MISC] updated CHANGELOG.md style, [@miketheman][]

#### Dependency Note
One of the dependencies of this cookbook is the `apt` cookbook.
A change introduced in the `apt` cookbook 2.0.0 release was a Chef 11-specific feature that would break on any Chef 10 system, so we considered adding a restriction in our `metadata.rb` to anything below 2.0.0.

A fix has gone in to `apt` 2.1.0 that relaxes this condition, and plays well with both Chef 10 and 11. We recommend using this version, or higher.

# 1.0.1 / 2013-05-14

* Fixed iis and rabbitmq template syntax - [#58][] [@gregf][]
* Updated style/spacing in ActiveMQ template
* Updated test suite to validate cookbook & templates
* Updated chefignore to clean the built cookbook from containing cruft

# 1.0.0 / 2013-05-06

* **BREAKING CHANGE**: Moved all attributes into `datadog` namespace - [#46][] ([#23][], [#26][])

  Reasoning behind this was that originally we attempted to auto-detect many common attributes and deploy automatic monitoring for them.
  We found that since inclusion of the `datadog` cookbook early in the run list caused the compile phase to be populated with our defaults (mostly `nil`), instead of the desired target, and namespacing of the attributes became necessary.

* **NEW PROVIDER**: Added a new `datadog_monitor` provider for integration use

  The new provider is used in many pre-provided integration recipes, such as `datadog::apache`.
  This enables a run list to include this recipe, as well as populate a node attribute with the needed instance details to monitor the given service

* Updated dependencies in Gemfile, simplifies travis build - [#34][], [#55][]
* Much improved test system (chefspec, test-kitchen) - [#35][] & others
* Tests against multiple versions of Chef - [#18][]
* Added language-specific recipes for installing `dogstatsd` - ([#28][])
* Added ability to control `dogstatsd` from agent config via attribute - [#27][]
* Placed the `dogstatsd` log file in `/var/log/` instead of `/tmp`
* Added attribute to configure dogstreams in `datadog.conf` - [#37][]
* Updated for `platform_family` semantics
* Added `node['datadog']['agent_version']` attribute
* (Handler Recipe) Better handling of EC2 instance ID for Handler - [#44][]
* Updated for agent 3.6.x logging syntax
* Generated config file removes some whitespace - [#56][]
* Removed dependency on `yum::epel`, only uses `yum` for the `repository` recipe


# 0.1.4 / 2013-04-25
* Quick fix for backporting test code to support upload in ruby 1.8.7

# 0.1.3 / 2013-01-27
* Work-around for COOK-2171

# 0.1.2 / 2012-10-15
* Fixed typo in jmx section

# 0.1.1 / 2012-09-18
* Added support for postgres, redis & memcached
* `dd-agent` - updated to include more platforms
* `dd-handler` - updated to leverage `chef_gem` resource if available
* Updated copyright for 2012
* Updated syntax for node attribute accessors
* Some syntax styling fixes
* Added agent logging configuration
* Removed extraneous dependencies
* Added automated testing suite

# 0.0.12
* Updated for CentOS dependencies

# 0.0.11
* Link to github repository.

# 0.0.10
* `dd-handler` - Corrects attribute name.

# 0.0.9
* `dd-agent` - Adds an explicit varnish attribute.

# 0.0.8
* `dd-agent` - Add varnish support.

# 0.0.7
* `dd-agent` - default to using instance IDs as hostnames when running dd-agent on EC2

# 0.0.5
* `dd-agent` - Full datadog.conf template using attributes (thanks [@drewrothstein][])

# 0.0.4
* `dd-agent` - Added support for Nagios PerfData and Graphite.

# 0.0.3
* `dd-agent` - Added support for RPM installs - Red Hat, CentOS, Scientific, Fedora

# 0.0.2
* Initial refactoring, including the `dd-agent` cookbook here
* Adding chef-handler-datadog to report to the newsfeed
* Added ruby-dev dependency

<!--- The following link definition list is generated by PimpMyChangelog --->
[#18]: https://github.com/DataDog/chef-datadog/issues/18
[#22]: https://github.com/DataDog/chef-datadog/issues/22
[#23]: https://github.com/DataDog/chef-datadog/issues/23
[#26]: https://github.com/DataDog/chef-datadog/issues/26
[#27]: https://github.com/DataDog/chef-datadog/issues/27
[#28]: https://github.com/DataDog/chef-datadog/issues/28
[#34]: https://github.com/DataDog/chef-datadog/issues/34
[#35]: https://github.com/DataDog/chef-datadog/issues/35
[#37]: https://github.com/DataDog/chef-datadog/issues/37
[#44]: https://github.com/DataDog/chef-datadog/issues/44
[#46]: https://github.com/DataDog/chef-datadog/issues/46
[#55]: https://github.com/DataDog/chef-datadog/issues/55
[#56]: https://github.com/DataDog/chef-datadog/issues/56
[#58]: https://github.com/DataDog/chef-datadog/issues/58
[#59]: https://github.com/DataDog/chef-datadog/issues/59
[#60]: https://github.com/DataDog/chef-datadog/issues/60
[#61]: https://github.com/DataDog/chef-datadog/issues/61
[#63]: https://github.com/DataDog/chef-datadog/issues/63
[#65]: https://github.com/DataDog/chef-datadog/issues/65
[#66]: https://github.com/DataDog/chef-datadog/issues/66
[#67]: https://github.com/DataDog/chef-datadog/issues/67
[#74]: https://github.com/DataDog/chef-datadog/issues/74
[#76]: https://github.com/DataDog/chef-datadog/issues/76
[#77]: https://github.com/DataDog/chef-datadog/issues/77
[#79]: https://github.com/DataDog/chef-datadog/issues/79
[#80]: https://github.com/DataDog/chef-datadog/issues/80
[#81]: https://github.com/DataDog/chef-datadog/issues/81
[#82]: https://github.com/DataDog/chef-datadog/issues/82
[#83]: https://github.com/DataDog/chef-datadog/issues/83
[#84]: https://github.com/DataDog/chef-datadog/issues/84
[#86]: https://github.com/DataDog/chef-datadog/issues/86
[#88]: https://github.com/DataDog/chef-datadog/issues/88
[#89]: https://github.com/DataDog/chef-datadog/issues/89
[#90]: https://github.com/DataDog/chef-datadog/issues/90
[#93]: https://github.com/DataDog/chef-datadog/issues/93
[#94]: https://github.com/DataDog/chef-datadog/issues/94
[#95]: https://github.com/DataDog/chef-datadog/issues/95
[#97]: https://github.com/DataDog/chef-datadog/issues/97
[#98]: https://github.com/DataDog/chef-datadog/issues/98
[#100]: https://github.com/DataDog/chef-datadog/issues/100
[#101]: https://github.com/DataDog/chef-datadog/issues/101
[#103]: https://github.com/DataDog/chef-datadog/issues/103
[#105]: https://github.com/DataDog/chef-datadog/issues/105
[#113]: https://github.com/DataDog/chef-datadog/issues/113
[@JoeDeVries]: https://github.com/JoeDeVries
[@alexism]: https://github.com/alexism
[@alq]: https://github.com/alq
[@antonio-osorio]: https://github.com/antonio-osorio
[@babbottscott]: https://github.com/babbottscott
[@clofresh]: https://github.com/clofresh
[@coosh]: https://github.com/coosh
[@drewrothstein]: https://github.com/drewrothstein
[@dwradcliffe]: https://github.com/dwradcliffe
[@elijahandrews]: https://github.com/elijahandrews
[@evan2645]: https://github.com/evan2645
[@flah00]: https://github.com/flah00
[@gregf]: https://github.com/gregf
[@jedi4ever]: https://github.com/jedi4ever
[@jtimberman]: https://github.com/jtimberman
[@mfischer-zd]: https://github.com/mfischer-zd
[@miketheman]: https://github.com/miketheman
[@nkts]: https://github.com/nkts
[@phlipper]: https://github.com/phlipper
[@qqfr2507]: https://github.com/qqfr2507
[@remh]: https://github.com/remh
[@ryandjurovich]: https://github.com/ryandjurovich
[@schisamo]: https://github.com/schisamo
[@thisismana]: https://github.com/thisismana
[@timusg]: https://github.com/timusg
