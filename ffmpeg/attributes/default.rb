#
# Cookbook Name:: ffmpeg
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

default[:ffmpeg][:install_method] = :source
default[:ffmpeg][:prefix] = "/usr/local"
default[:ffmpeg][:git_repository] = "git@github.com:YesVideo/FFmpeg.git"
default[:ffmpeg][:compile_flags] = [
  "--disable-debug",
  "--enable-pthreads",
  "--enable-nonfree",
  "--enable-gpl",
  "--disable-indev=jack",
  "--enable-libx264",
  "--enable-libfaac",
  "--enable-libmp3lame",
  "--enable-libtheora",
  "--enable-libvorbis",
  "--enable-libvpx",
  "--enable-libxvid",
#  "--enable-libfaad" does not work with new ffmpeg version anymore
]

# JW 07-06-11: Hash of commit or a HEAD should be used - not a tag. Sync action of Git
# provider will always attempt to update the git clone if a tag is used.
#default[:ffmpeg][:git_revision] = "9f82cbf7c11b2eca98a38fc9f1ca3a2ba1066a36" # head of release/0.10
default[:ffmpeg][:git_revision] = "HEAD" # head of release/0.12
