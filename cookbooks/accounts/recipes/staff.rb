#
# Cookbook Name:: accounts
# Recipe:: staff
#
# Copyright 2009, Alexander van Zoest
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

include_recipe "accounts::sysadmins"

# Here you can put account definitions for each account you want installed when someone includes
# include_recipe "accounts::staff"


#account "employee1" do
#  uid "1000"
#  account_type "user"
#  comment "Employee #1"
#  password "somepass"
#  ssh true
#  sudo false
#end

