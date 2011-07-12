#
# Cookbook Name:: elasticsearch
# Recipe:: autoconf
#
# Copyright 2010, GoTime
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


##TODO use a databag for configuration per cluster, similar to cassandra cookbook
#cluster = data_bag_item('elasticsearch', node[:elasticsearch][:cluster_name])
#cluster.each_pair do |k, v|
#  node[:elasticsearch][k] = v #TODO should do a deep merge here
#end
#node.save

seeds = search(:node, "elasticsearch_cluster_name:#{node[:elasticsearch][:cluster_name]} AND elasticsearch_seed:true").sort_by { |n| n.name }.collect {|n| n["ipaddress"]}
node[:elasticsearch][:seeds] = seeds

include_recipe "elasticsearch::default"
