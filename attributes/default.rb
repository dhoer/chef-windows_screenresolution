default['windows_screenresolution']['username'] = nil
default['windows_screenresolution']['password'] = nil
default['windows_screenresolution']['width'] = 1920
default['windows_screenresolution']['height'] = 1080

default['windows_screenresolution']['target'] = 'localhost'
default['windows_screenresolution']['rdp_autologon'] = true
default['windows_screenresolution']['rdp_autologin'] = node['windows_screenresolution']['rdp_autologon']
default['windows_screenresolution']['rdp_groups'] = ['Administrators', 'Remote Desktop Users']
default['windows_screenresolution']['rdp_username'] = 'rdp_local'
default['windows_screenresolution']['rdp_password'] = nil
default['windows_screenresolution']['rdp_domain'] = nil
