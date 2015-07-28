require 'spec_helper'

describe 'windows_screenresolution::default' do
  context 'windows' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'windows', version: '2012R2') do |node|
        node.set['windows_screenresolution']['width'] = 1440
        node.set['windows_screenresolution']['height'] = 900
        node.set['windows_screenresolution']['username'] = 'newuser'
        node.set['windows_screenresolution']['password'] = 'N3wPassW0Rd'
        stub_command("netsh advfirewall firewall show rule name=\"RDP\" > nul").and_return(nil)
      end.converge(described_recipe)
    end

    it 'creates user' do
      expect(chef_run).to create_user('rdp_local').with(
        password: 'N3wPassW0Rd'
      )
    end

    it 'adds Administrators to group' do
      expect(chef_run).to modify_group('Administrators').with(
        members: ['rdp_local'],
        append: true
      )
    end

    it 'adds Remote Desktop Users to group' do
      expect(chef_run).to modify_group('Remote Desktop Users').with(
        members: ['rdp_local'],
        append: true
      )
    end

    it "generates user's home directory" do
      expect(chef_run).to create_windows_home('rdp_local').with(
        password: 'N3wPassW0Rd'
      )
    end

    it 'creates startup directory' do
      expect(chef_run).to run_ruby_block('hack to mkdir on windows')
    end

    it 'creates rdp screen resolution startup script' do
      expect(chef_run).to create_template(
        'C:/Users/rdp_local/AppData/Roaming/Microsoft/Windows/Start Menu/Programs/Startup/rdp_screenresolution.cmd')
        .with(
          variables: {
            target: 'localhost',
            user: 'newuser',
            password: 'N3wPassW0Rd',
            width: 1440,
            height: 900
          }
        )
    end

    it 'enables remote desktop connections' do
      expect(chef_run).to create_registry_key('HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server').with(
        values: [
          { name: 'fDenyTSConnections', type: :dword, data: 'cfcd208495d565ef66e7dff9f98764da' }
        ]
      )
    end

    it 'suppresses certificate error popup for rdp logins' do
      expect(chef_run).to create_registry_key('HKLM\SOFTWARE\Microsoft\Terminal Server Client').with(
        values: [
          { name: 'AuthenticationLevelOverride', type: :dword, data: 'cfcd208495d565ef66e7dff9f98764da' }
        ]
      )
    end

    it 'opens firewall for rdp' do
      expect(chef_run).to run_execute('open rdp firewall')
    end

    it 'enables autologon for user' do
      expect(chef_run).to include_recipe('windows_autologin::default')
    end

    it 'logs display resolution' do
      expect(chef_run).to write_log('screenresolution 1440x900')
    end
  end

  context 'non_windows' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(step_into: ['windows_screenresolution']).converge(described_recipe)
    end

    it 'should warn if not Windows platform' do
      expect(chef_run).to write_log('The windows_screenresolution cookbook is only for Windows platform!')
    end
  end
end
