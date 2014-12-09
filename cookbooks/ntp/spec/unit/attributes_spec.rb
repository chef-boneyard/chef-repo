#
# Cookbook Name:: ntp
# Test:: attributes_spec
#
# Author:: Fletcher Nichol
# Author:: Eric G. Wolfe
#
# Copyright 2012, Fletcher Nichol
# Copyright 2012, Eric G. Wolfe
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

require 'spec_helper'

describe 'ntp attributes' do
  let(:chef_run) { ChefSpec::SoloRunner.new.converge('ntp::default') }
  let(:ntp) { chef_run.node['ntp'] }

  describe 'on an unknown platform' do

    it 'sets the package list to ntp & ntpdate' do
      expect(ntp['packages']).to include('ntp')
      expect(ntp['packages']).to include('ntpdate')
    end

    it 'sets the service name to ntpd' do
      expect(ntp['service']).to eq('ntpd')
    end

    it 'sets the /var/lib directory' do
      expect(ntp['varlibdir']).to eq('/var/lib/ntp')
    end

    it 'sets the driftfile to /var/lib/ntp.drift' do
      expect(ntp['driftfile']).to eq('/var/lib/ntp/ntp.drift')
    end

    it 'sets the conf file to /etc/ntp.conf' do
      expect(ntp['conffile']).to eq('/etc/ntp.conf')
    end

    it 'sets the stats directory to /var/log/ntpstats/' do
      expect(ntp['statsdir']).to eq('/var/log/ntpstats/')
    end

    it 'sets the conf_owner to root' do
      expect(ntp['conf_owner']).to eq('root')
    end

    it 'sets the conf_group to root' do
      expect(ntp['conf_group']).to eq('root')
    end

    it 'sets the var_owner to root' do
      expect(ntp['var_owner']).to eq('ntp')
    end

    it 'sets the var_group to root' do
      expect(ntp['var_group']).to eq('ntp')
    end

    it 'sets the leapfile to /etc/ntp.leapseconds' do
      expect(ntp['leapfile']).to eq('/etc/ntp.leapseconds')
    end

    it 'sets the upstream server list in the recipe' do
      expect(ntp['servers']).to include('0.pool.ntp.org')
    end

    it 'sets apparmor_enabled to false' do
      expect(ntp['apparmor_enabled']).to eq(false)
    end

    it 'sets monitor to false' do
      expect(ntp['monitor']).to eq(false)
    end
  end

  describe 'on Debian-family platforms' do
    let(:chef_run) { ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '12.04').converge('ntp::default') }

    it 'sets the service name to ntp' do
      expect(ntp['service']).to eq('ntp')
    end
  end

  describe 'on Ubuntu' do
    let(:chef_run) { ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '12.04').converge('ntp::default') }

    it 'sets the apparmor_enabled attribute to true' do
      expect(ntp['apparmor_enabled']).to eq(true)
    end
  end

  describe 'on the CentOS 5 platform' do
    let(:chef_run) { ChefSpec::SoloRunner.new(platform: 'centos', version: '5.8').converge('ntp::default') }

    it 'sets the package list to only ntp' do
      expect(ntp['packages']).to include('ntp')
      expect(ntp['packages']).not_to include('ntpdate')
    end
  end

  describe 'on the Windows platform' do
    let(:chef_run) { ChefSpec::SoloRunner.new(platform: 'windows', version: '2008R2').converge('ntp::default') }

    # chefspec can not check windows reliably so skip these tests for now
    it 'sets the service name to NTP'

    it 'sets the drift file to /var/db/ntpd.drift'

    it 'sets the conf file to /etc/ntp.conf'

    it 'sets the conf_owner to root'

    it 'sets the conf_group to root'

    it 'sets the package_url correctly'

    it 'sets the vs_runtime_url correctly'

    it 'sets the vs_runtime_productname correctly'

=begin
    it 'sets the service name to NTP' do
      pending('ChefSpec does not yet understand the inherits attribute in cookbook_file resources')
      expect(ntp['service']).to eq('NTP')
    end

    it 'sets the drift file to /var/db/ntpd.drift' do
      pending('ChefSpec does not yet understand the inherits attribute in cookbook_file resources')
      expect(ntp['driftfile']).to eq('C:\\NTP\\ntp.drift')
    end

    it 'sets the conf file to /etc/ntp.conf' do
      pending('ChefSpec does not yet understand the inherits attribute in cookbook_file resources')
      expect(ntp['conffile']).to eq('C:\\NTP\\etc\\ntp.conf')
    end

    it 'sets the conf_owner to root' do
      pending('ChefSpec does not yet understand the inherits attribute in cookbook_file resources')
      expect(ntp['conf_owner']).to eq('Administrators')
    end

    it 'sets the conf_group to root' do
      pending('ChefSpec does not yet understand the inherits attribute in cookbook_file resources')
      expect(ntp['conf_group']).to eq('Administrators')
    end

    it 'sets the package_url correctly' do
      pending('ChefSpec does not yet understand the inherits attribute in cookbook_file resources')
      expect(ntp['package_url']).to eq('http://www.meinbergglobal.com/download/ntp/windows/ntp-4.2.6p5@london-o-lpv-win32-setup.exe')
    end

    it 'sets the vs_runtime_url correctly' do
      pending('ChefSpec does not yet understand the inherits attribute in cookbook_file resources')
      expect(ntp['vs_runtime_url']).to eq('http://download.microsoft.com/download/1/1/1/1116b75a-9ec3-481a-a3c8-1777b5381140/vcredist_x86.exe')
    end

    it 'sets the vs_runtime_productname correctly' do
      pending('ChefSpec does not yet understand the inherits attribute in cookbook_file resources')
      expect(ntp['vs_runtime_productname']).to eq('Microsoft Visual C++ 2008 Redistributable - x86 9.0.21022')
    end
=end

  end

  describe 'on the FreeBSD platform' do
    let(:chef_run) { ChefSpec::SoloRunner.new(platform: 'freebsd', version: '9.1').converge('ntp::default') }

    it 'sets the package list to only ntp' do
      expect(ntp['packages']).to include('ntp')
      expect(ntp['packages']).not_to include('ntpdate')
    end

    it 'sets the var directories to /var/db' do
      expect(ntp['varlibdir']).to eq('/var/db')
    end

    it 'sets the drift file to /var/db/ntpd.drift' do
      expect(ntp['driftfile']).to eq('/var/db/ntpd.drift')
    end

    it 'sets the stats directory to /var/db/ntpstats' do
      expect(ntp['statsdir']).to eq('/var/db/ntpstats')
    end

    it 'sets the conf_group to wheel' do
      expect(ntp['conf_group']).to eq('wheel')
    end

    it 'sets the var_group to wheel' do
      expect(ntp['var_group']).to eq('wheel')
    end
  end
end
