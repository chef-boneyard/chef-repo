#
# Cookbook Name:: mysql
# Attributes:: client
#
# Copyright 2013, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

default['mysql']['percona']['apt_key_id'] = 'CD2EFD2A'
default['mysql']['percona']['apt_uri'] = 'http://repo.percona.com/apt'
default['mysql']['percona']['apt_keyserver'] = 'keys.gnupg.net'
