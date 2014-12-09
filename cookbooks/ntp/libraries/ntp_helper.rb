#
# Author:: Julian C. Dunn (<jdunn@getchef.com>)
# Cookbook Name:: ntp
# Library:: helper
#
# Copyright:: 2014, Chef Software, Inc.
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

require 'chef/mixin/shell_out'

module Opscode
  module Ntp
    # Helper methods for ntp
    module Helper
      include Chef::Mixin::ShellOut

      def ntpd_supports_native_leapfiles
        ntpd_version = determine_ntpd_version
        if ntpd_version
          ntpd_version =~ /ntpd.*(\d+\.\d+\.\d+)/
          # Abuse of Gem::Requirement, but it works
          Gem::Requirement.new('>= 4.2.6').satisfied_by?(Gem::Version.new(Regexp.last_match(1)))
        else
          false
        end
      end

      private

      def determine_ntpd_version
        cmd = shell_out!('ntpd --version 2>&1')
        cmd.stdout.strip
      rescue Errno::ENOENT, Mixlib::ShellOut::ShellCommandFailed
        nil
      end
    end
  end
end
