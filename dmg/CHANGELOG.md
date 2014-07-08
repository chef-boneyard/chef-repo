dmg Cookbook CHANGELOG
======================
This file is used to list changes made in each version of the dmg ookbook.


v2.0.0
------
### Bug
- **[COOK-3389](https://tickets.opscode.com/browse/COOK-3389)** - Use `rsync` instead of `cp` (potentially a breaking change on some systems)

v1.1.0
------
- [COOK-1847] - accept owner parameter for installing packages

v1.0.0
------
- [COOK-852] - Support "pkg" in addition to "mpkg" package types

v0.7.0
------
- [COOK-854] - use `cp -R` instead of `cp -r`
- [COOK-855] - specify a file or directory to check for prior install

v0.6.0
------
- option to install software that is an .mpkg inside a .dmg
- ignore failure on chmod in case mode is already set, or is root owned
