# Windows Screen Resolution Cookbook

[![Cookbook Version](http://img.shields.io/cookbook/v/windows_screenresolution.svg?style=flat-square)][cookbook]
[![Build Status](https://img.shields.io/appveyor/ci/dhoer/chef-windows-screenresolution/master.svg?style=flat-square)][win]

[cookbook]: https://supermarket.chef.io/cookbooks/windows_screenresolution
[win]: https://ci.appveyor.com/project/dhoer/chef-windows-screenresolution

Sets headless screen resolution on Windows.  

It does this by:
 
- creating a new user called `rdp_local` 
- creating a startup script to RDP into the specified user account at specified resolution (default is 1920x1080) 
- adding a firewall rule to open RDP port 3389
- configuring auto-logon to login as `rdp_local` on reboot

Note that auto-logon requires a username and password and that the password is stored unencrypted under 
windows registry `HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon`.

Tested on Amazon Windows Server 2012 R2 AMI.

## Requirements

- Chef 11.6+ (registry_key resource)
- Windows Server 2008 R2+ (due to usage of [window_home](https://github.com/dhoer/chef-windows_home))

## Platforms

- Windows

## Dependencies

- windows_autologin
- windows_home

## Usage

Include default recipe in run list or in another cookbook to set the screen resolution. 
The `username` and `password` must be set in order to user this cookbook.  

#### Attributes

- `node['windows_screenresolution']['username']` - Username of account to remote login as (required).
- `node['windows_screenresolution']['password']` - Password of account to remote login as (required).
- `node['windows_screenresolution']['width']` -  Display width in pixels. Defaults to `1920`.
- `node['windows_screenresolution']['height']` - Display height in pixels. Defaults to `1080`.
- `node['windows_screenresolution']['target']` -   Identifies the computer or domain name that username and password 
account will be associated with for remote login. Defaults to `localhost`.
- `node['windows_screenresolution']['rdp_autologon']` - Logon as RDP user automatically on reboot. Defaults to `true`. 
Note that the password is stored unencrypted under windows registry 
`HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon`.
- `node['windows_screenresolution']['rdp_username']` -  RDP username. Defaults to `rdp_local`.
- `node['windows_screenresolution']['rdp_password']` - RDP password. Defaults to password of account to remote login 
as, if `nil`.
- `node['windows_screenresolution']['rdp_domain']` -  RDP domain. Defaults to `nil`.

#### Examples

Set newuser's screen resolution to `1920x1080` (default)

```ruby
node.override['windows_screenresolution']['username'] = 'newuser'
node.override['windows_screenresolution']['password'] = 'N3wPassW0Rd'

include_recipe 'windows_screenresolution::default'
```

Set newuser's screen resolution to `1366x768`

```ruby
node.override['windows_screenresolution']['username'] = 'newuser'
node.override['windows_screenresolution']['password'] = 'N3wPassW0Rd'
node.override['windows_screenresolution']['width'] = 1366
node.override['windows_screenresolution']['height'] = 768

include_recipe 'windows_screenresolution::default'
```

## Getting Help

- Ask specific questions on [Stack Overflow](http://stackoverflow.com/questions/tagged/chef-windows_screenresolution).
- Report bugs and discuss potential features in 
[Github issues](https://github.com/dhoer/chef-windows_screenresolution/issues).

## Contributing

Please refer to [CONTRIBUTING](https://github.com/dhoer/chef-windows_screenresolution/blob/master/CONTRIBUTING.md).

## License

MIT - see the accompanying [LICENSE](https://github.com/dhoer/chef-windows_screenresolution/blob/master/LICENSE.md) 
file for details.
