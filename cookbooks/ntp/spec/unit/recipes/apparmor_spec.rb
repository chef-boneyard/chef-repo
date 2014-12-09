require 'spec_helper'

describe 'ntp::apparmor' do
  let(:chef_run) { ChefSpec::SoloRunner.new.converge('recipe[ntp::apparmor]') }

  it 'creates the apparmor file' do
    expect(chef_run).to create_cookbook_file '/etc/apparmor.d/usr.sbin.ntpd'
    file = chef_run.cookbook_file('/etc/apparmor.d/usr.sbin.ntpd')
    expect(file.owner).to eq('root')
    expect(file.group).to eq('root')
  end

  it 'restarts the apparmor service' do
    expect(chef_run.cookbook_file('/etc/apparmor.d/usr.sbin.ntpd')).to notify('service[apparmor]').to(:restart)
  end

end
