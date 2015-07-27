require 'serverspec_helper'

describe 'windows_screenresolution::default' do
  if os[:family] == 'windows'
    describe file('C:/Users/rdp_local/AppData/Roaming/Microsoft/Windows/Start Menu/Programs/Startup') do
      it { should be_directory }
    end

    describe file(
      'C:/Users/rdp_local/AppData/Roaming/Microsoft/Windows/Start Menu/Programs/Startup/rdp_screenresolution.cmd') do
      it { should be_file }
    end
  end
end
