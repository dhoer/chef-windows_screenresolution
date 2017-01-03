windows_screenresolution node['windows_screenresolution']['username'] do
  password node['windows_screenresolution']['password']
  width node['windows_screenresolution']['width']
  height node['windows_screenresolution']['height']
  target node['windows_screenresolution']['target']
  rdp_autologin node['windows_screenresolution']['rdp_autologin']
  rdp_groups node['windows_screenresolution']['rdp_groups']
  rdp_username node['windows_screenresolution']['rdp_username']
  rdp_password node['windows_screenresolution']['rdp_password']
  rdp_domain node['windows_screenresolution']['rdp_domain']
  action :run
end
