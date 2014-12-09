require 'spec_helper'

describe 'ntp::undo' do
  let(:chef_run) { ChefSpec::SoloRunner.new.converge('ntp::undo') }

  it 'stops the ntpd service' do
    expect(chef_run).to stop_service('ntpd')
  end

  it 'sets the ntpd service not to start on boot' do
    expect(chef_run).to_not enable_service('ntpd')
  end

  it 'uninstalls the ntp package' do
    expect(chef_run).to remove_package('ntp')
  end

  it 'uninstalls the ntpdate package' do
    expect(chef_run).to remove_package('ntpdate')
  end
end
