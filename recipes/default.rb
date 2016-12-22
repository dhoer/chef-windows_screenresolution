if platform?('windows')
  rdp_user = if node['windows_screenresolution']['rdp_domain'].nil?
               node['windows_screenresolution']['rdp_username']
             else
               "#{node['windows_screenresolution']['rdp_domain']}\\#{node['windows_screenresolution']['rdp_username']}"
             end

  rdp_password = if node['windows_screenresolution']['rdp_password'].nil?
                   node['windows_screenresolution']['password']
                 else
                   node['windows_screenresolution']['rdp_password']
                 end

  user rdp_user do
    password rdp_password
  end

  node['windows_screenresolution']['rdp_groups'].each do |group|
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

  startup_path = "C:/Users/#{node['windows_screenresolution']['rdp_username']}"\
    '/AppData/Roaming/Microsoft/Windows/Start Menu/Programs/Startup'

  ruby_block 'hack to mkdir on windows' do
    block do
      ::FileUtils.mkdir_p startup_path
    end
    not_if { ::File.exist?(startup_path) }
  end

  template "#{startup_path}/rdp_screenresolution.cmd" do
    source 'rdp_screenresolution.cmd.erb'
    cookbook 'windows_screenresolution'
    sensitive true
    variables(target: node['windows_screenresolution']['target'],
              user: node['windows_screenresolution']['username'],
              password: node['windows_screenresolution']['password'].gsub('%', '%%'),
              width: node['windows_screenresolution']['width'],
              height: node['windows_screenresolution']['height'])
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
  if node['windows_screenresolution']['rdp_autologon']
    node.override['windows_autologin']['username'] = node['windows_screenresolution']['rdp_username']
    node.override['windows_autologin']['password'] = rdp_password
    node.override['windows_autologin']['domain'] = node['windows_screenresolution']['rdp_domain']

    include_recipe 'windows_autologin::default'
  end

  Chef::Log.info('screenresolution '\
    "#{node['windows_screenresolution']['width']}x#{node['windows_screenresolution']['height']}")
else
  Chef::Log.warn('windows_screenresolution cookbook is only for windows platform!')
end
