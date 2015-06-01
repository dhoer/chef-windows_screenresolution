require 'spec_helper'

describe 'windows_screenresolution_test::screenresolution' do
  before do
    stub_command("netsh advfirewall firewall show rule name=\"RDP\" > nul").and_return(true)
  end

  context 'server_core_cmdlets' do
    let(:shellout) { double(:live_stream= => nil, live_stream: nil, run_command: nil, stdout: '1600x1200') }
    # let(:dummy_class) { Class.new { include Chef::Recipe } }

    let(:chef_run) do
      ChefSpec::SoloRunner.new(file_cache_path: 'c:/chef/cache', platform: 'windows', version: '2012R2') do |node|
        node.set['windows_screenresolution']['width'] = 1440
        node.set['windows_screenresolution']['height'] = 900
        node.set['windows_screenresolution']['username'] = 'newuser'
        node.set['windows_screenresolution']['password'] = 'N3wPassW0Rd'
        windows_version = double
        allow(windows_version).to receive(:windows_server_2012_r2?).and_return(true)
        allow_any_instance_of(Chef::Recipe).to receive(:windows_version).and_call_original
        allow_any_instance_of(Chef::Recipe).to receive(:windows_version).and_return(windows_version)
        allow(Mixlib::ShellOut).to receive(:new).and_return(shellout)
      end.converge(described_recipe)
    end

    it 'returns screen resolution' do
      expect(chef_run).to write_log('Screen resolution: 1600x1200')
    end
  end

  context 'no_server_core_cmdlets' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'windows', version: '2008R2') do |node|
        node.set['windows_screenresolution']['width'] = 1440
        node.set['windows_screenresolution']['height'] = 900
        node.set['windows_screenresolution']['username'] = 'newuser'
        node.set['windows_screenresolution']['password'] = 'N3wPassW0Rd'
        windows_version = double
        allow(windows_version).to receive(:windows_server_2012_r2?).and_return(false)
        allow_any_instance_of(Chef::Recipe).to receive(:windows_version).and_call_original
        allow_any_instance_of(Chef::Recipe).to receive(:windows_version).and_return(windows_version)
      end.converge(described_recipe)
    end

    it 'should warn if not Windows Server 2012 R2' do
      expect(chef_run).to write_log('Method screenresolution is only for Windows Server 2012 R2!')
    end
  end

  context 'non_windows' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new.converge(described_recipe)
    end

    it 'should warn if not Windows platform' do
      expect(chef_run).to write_log('Method screenresolution is only available for Windows platform!')
    end
  end
end
