Description
===========

Installs the cron package and starts the crond service.

Requirements
============

Platforms:

* RHEL family
* Debian family

Resources and Providers
=======================

`cron_d`
--------

The `cron_d` LWRP can be used to manage files in `/etc/cron.d`. It supports
the same interface as Chef's built-in `cron` resource:

    cron_d "daily-usage-report" do
      minute 0
      hour 23
      command "/srv/app/scripts/daily_report"
      user "appuser"
    end

LWRP attributes:

* `minute`, `hour`, `day`, `month`, `weekday`
    * Schedule your cron job. These correspond exactly to their equivalents in
      the crontab file. All default to "*".
* `command`
    * The command to run. Required.
* `user`
    * The user to run as. Defaults to "root".
* `mailto`, `path`, `home`, `shell`
    * Set the corresponding environment variables in the cron.d file. No
      default.

License and Author
==================

Author:: Joshua Timberman (<joshua@opscode.com>)

Copyright 2010-2012, Opscode, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
