#
# Cookbook Name:: libvpx
# Attributes:: default
#
# Author:: Jamie Winsor (<jamie@vialstudios.com>)
#
# Copyright 2011, En Masse Entertainment, Inc.
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

default[:libvpx][:install_method] = :source
default[:libvpx][:git_repository] = "http://git.chromium.org/webm/libvpx.git"
default[:libvpx][:prefix] = "/usr/local"

# JW 07-06-11: Hash of commit or a HEAD should be used - not a tag. Sync action of Git
# provider will always attempt to update the git clone if a tag is used.
default[:libvpx][:git_revision]   = "0491c2cfc89cded04de386ae691654c7653aac9b" # v0.9.6
