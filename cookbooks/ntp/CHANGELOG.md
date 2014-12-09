ntp Cookbook CHANGELOG
======================
This file is used to list changes made in each version of the ntp cookbook.

v1.6.8 (2014-12-04)
-------------------
- **[PR #81](https://github.com/gmiranda23/ntp/pull/81)** - Update to berkshelf3

v1.6.6 (2014-12-02)
-------------------
- **[PR #76](https://github.com/gmiranda23/ntp/pull/76)** - Overhauled Testing
- **[PR #68](https://github.com/gmiranda23/ntp/pull/68)** - Updated Leapseconds
- **[PR #51](https://github.com/gmiranda23/ntp/pull/51)** - Berksfile source deprecation

v1.6.5 (2014-09-25)
-------------------
- Ensure that ntp version is captured

v1.6.4 (2014-07-02)
-------------------
- Leapseconds File Expired, update to 3626380800
- **[COOK-3887](https://tickets.opscode.com/browse/COOK-3887)** - Trivial changes to achieve Gentoo support
- **[COOK-1876](https://tickets.opscode.com/browse/COOK-1876)** - ntp leapfile assumes ntpd >= 4.2.6 syntax

v1.6.2 (2014-03-19)
-------------------
- [COOK-4162] - change "No NTP servers specified" message to :debug

v1.6.0 (2014-02-21)
-------------------
### Improvement
- **[COOK-4346](https://tickets.opscode.com/browse/COOK-4346)** - Solaris 11 support for ntp
- **[COOK-4339](https://tickets.opscode.com/browse/COOK-4339)** - Disable Monitoring by Default
- **[COOK-3604](https://tickets.opscode.com/browse/COOK-3604)** - Enable listening on specific interfaces

### Bug
- **[COOK-4106](https://tickets.opscode.com/browse/COOK-4106)** - Check for default content in ntp.conf
- **[COOK-4087](https://tickets.opscode.com/browse/COOK-4087)** - quote option in readme
- **[COOK-3797](https://tickets.opscode.com/browse/COOK-3797)** - Cookbook fails to upload due to 1.9.x syntax
- **[COOK-3023](https://tickets.opscode.com/browse/COOK-3023)** - NTP leapseconds file denied by Ubuntu apparmor profile


v1.5.4 (2013-12-29)
-------------------
[COOK-4007]- update to 3612902400


v1.5.2
------
### Bug
- **[COOK-3797](https://tickets.opscode.com/browse/COOK-3797)** - Add /spec to Chefignore

v1.5.0
------
### Improvement
- **[COOK-3651](https://tickets.opscode.com/browse/COOK-3651)** - Refactor and clean up
- **[COOK-3630](https://tickets.opscode.com/browse/COOK-3630)** - Switch NTP cookbook linting from Tailor to Rubocop
- **[COOK-3273](https://tickets.opscode.com/browse/COOK-3273)** - Add tests

### New Feature
- **[COOK-3636](https://tickets.opscode.com/browse/COOK-3636)** - Allow ntp cookbook to update clock to ntp servers

### Bug
- **[COOK-3410](https://tickets.opscode.com/browse/COOK-3410)** - Remove redundant ntpdate/disable recipes
- **[COOK-1170](https://tickets.opscode.com/browse/COOK-1170)** - Allow redefining NTP servers in a role


v1.4.0
------
### Improvement
- **[COOK-3365](https://tickets.opscode.com/browse/COOK-3365)** - Update ntp leapseconds file to version 3597177600
- **[COOK-1674](https://tickets.opscode.com/browse/COOK-1674)** - Add Windows support

v1.3.2
------
- [COOK-2024] - update leapfile for IERS Bulletin C

v1.3.0
------
- [COOK-1404] - add leapfile for handling leap seconds

v1.2.0
------
- [COOK-1184] - Add recipe to disable NTP completely
- [COOK-1298] - Refactor into a reference cookbook for testing

v1.1.8
------
- [COOK-1158] - RHEL family >= 6 has ntpdate package

v1.1.6
------
- Related to changes in COOK-1124, fix group for freebsd and else

v1.1.4
------
- [COOK-1124] - parameterised driftfile and statsdir to be configurable by platform

v1.1.2
------
- [COOK-952] - freebsd support
- [COOK-949] - check for any virtual system not just vmware

v1.1.0
------
- Fixes COOK-376 (use LAN peers, iburst option, LAN restriction attribute)

v1.0.1
------
- Support scientific linux
- Use service name attribute in resource (fixes EL derivatives)
