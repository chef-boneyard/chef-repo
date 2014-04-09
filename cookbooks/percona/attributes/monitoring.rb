# Cookbook Name:: percona
# Attributes:: monitoring
#
# Copyright 2012, CX Inc.
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

default['percona']['plugins_version'] = version = "1.0.2"
default['percona']['plugins_url'] = "http://www.percona.com/downloads/percona-monitoring-plugins/#{version}/"
default['percona']['plugins_sha'] = "da84cfe89637292da15ddb1e66f67ad9703fa21392d8d49e664ad08f7aa45585"
default['percona']['plugins_path'] = "/opt/pmp"
