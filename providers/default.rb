use_inline_resources

def whyrun_supported?
  true
end

def rdp_password
  if new_resource.rdp_password.nil?
    new_resource.password
  else
    new_resource.rdp_password
  end
end

action :run do
  if platform?('windows')
    user new_resource.rdp_username do
      password rdp_password
    end

    new_resource.rdp_groups.each do |group|
      group group do
        members [new_resource.rdp_username]
        append true
        action :modify
      end
    end

    windows_home new_resource.rdp_username do
      password rdp_password
      confidential new_resource.confidential
      action :create
    end

    startup_path = "C:/Users/#{new_resource.rdp_username}"\
      '/AppData/Roaming/Microsoft/Windows/Start Menu/Programs/Startup'

    ruby_block 'hack to mkdir on windows' do
      block do
        ::FileUtils.mkdir_p startup_path
      end
      not_if { ::File.exist?(startup_path) }
    end

    password = new_resource.password
    password = password.gsub('%', '%%') unless password.nil?
    template "#{startup_path}/rdp_screenresolution.cmd" do
      source 'rdp_screenresolution.cmd.erb'
      cookbook 'windows_screenresolution'
      sensitive new_resource.confidential
      variables(
        target: new_resource.target,
        user: new_resource.username,
        password: password,
        width: new_resource.width,
        height: new_resource.height
      )
    end

    # https://technet.microsoft.com/en-us/library/cc722151%28v=ws.10%29.aspx
    registry_key 'HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server' do
      values [{ name: 'fDenyTSConnections', type: :dword, data: 0 }]
      sensitive new_resource.confidential
      action :create
    end

    # http://www.mytecbits.com/microsoft/windows/rdp-identity-of-the-remote-computer
    registry_key 'HKLM\SOFTWARE\Microsoft\Terminal Server Client' do
      values [{ name: 'AuthenticationLevelOverride', type: :dword, data: 0 }]
      sensitive new_resource.confidential
      action :create
    end

    execute 'open rdp firewall' do
      command 'netsh advfirewall firewall add rule name="RDP" protocol=TCP dir=in profile=public'\
      ' localport=3389 remoteip=localsubnet localip=any action=allow'
      sensitive new_resource.confidential
      not_if 'netsh advfirewall firewall show rule name="RDP" > nul'
    end

    windows_autologin "set #{new_resource.rdp_username}" do
      username new_resource.rdp_username
      password rdp_password
      confidential new_resource.confidential
      only_if { new_resource.rdp_autologin }
    end

    Chef::Log.info("windows_screenresolution #{new_resource.width}x#{new_resource.height}")
  else
    Chef::Log.warn('windows_screenresolution cookbook is only for windows platform!')
  end
end
