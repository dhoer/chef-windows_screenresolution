if platform?('windows')
  res = node['windows_screenresolution']
  rdp_user = res['rdp_domain'].nil? ? res['rdp_username'] : "#{res['rdp_domain']}\\#{res['rdp_username']}"
  rdp_password = res['rdp_password'].nil? ? res['password'] : res['rdp_password']

  user rdp_user do
    password rdp_password
  end

  res['rdp_groups'].each do |group|
    group group do
      members [rdp_user]
      append true
      action :modify
    end
  end

  windows_home rdp_user do
    password rdp_password
    action :create
  end

  startup_path = "C:/Users/#{res['rdp_username']}"\
    '/AppData/Roaming/Microsoft/Windows/Start Menu/Programs/Startup'

  ruby_block 'hack to mkdir on windows' do
    block do
      ::FileUtils.mkdir_p startup_path
    end
    not_if { ::File.exist?(startup_path) }
  end

  password = res['password']
  password = password.gsub('%', '%%') unless password.nil?
  template "#{startup_path}/rdp_screenresolution.cmd" do
    source 'rdp_screenresolution.cmd.erb'
    cookbook 'windows_screenresolution'
    sensitive true
    variables(
      target: res['target'],
      user: res['username'],
      password: password,
      width: res['width'],
      height: res['height']
    )
  end

  # https://technet.microsoft.com/en-us/library/cc722151%28v=ws.10%29.aspx
  registry_key 'HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server' do
    values [{ name: 'fDenyTSConnections', type: :dword, data: 0 }]
    action :create
  end

  # http://www.mytecbits.com/microsoft/windows/rdp-identity-of-the-remote-computer
  registry_key 'HKLM\SOFTWARE\Microsoft\Terminal Server Client' do
    values [{ name: 'AuthenticationLevelOverride', type: :dword, data: 0 }]
    action :create
  end

  execute 'open rdp firewall' do
    command 'netsh advfirewall firewall add rule name="RDP" protocol=TCP dir=in profile=public'\
      ' localport=3389 remoteip=localsubnet localip=any action=allow'
    action :run
    not_if 'netsh advfirewall firewall show rule name="RDP" > nul'
  end

  # https://docs.chef.io/attributes.html#attribute-precedence
  if res['rdp_autologon']
    node.override['windows_autologin']['username'] = res['rdp_username']
    node.override['windows_autologin']['password'] = rdp_password
    node.override['windows_autologin']['domain'] = res['rdp_domain']

    include_recipe 'windows_autologin::default'
  end

  Chef::Log.info("screenresolution #{res['width']}x#{res['height']}")
else
  Chef::Log.warn('windows_screenresolution cookbook is only for windows platform!')
end
