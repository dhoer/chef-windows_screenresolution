# Windows Screen Resolution Cookbook

[![Cookbook Version](http://img.shields.io/cookbook/v/windows_screenresolution.svg?style=flat-square)][cookbook]
[![Build Status](http://img.shields.io/travis/dhoer/chef-windows_screenresolution.svg?style=flat-square)][travis]
[![GitHub Issues](http://img.shields.io/github/issues/dhoer/chef-windows_screenresolution.svg?style=flat-square)]
[github]

[cookbook]: https://supermarket.chef.io/cookbooks/windows_screenresolution
[travis]: https://travis-ci.org/dhoer/chef-windows_screenresolution
[github]: https://github.com/dhoer/chef-windows_screenresolution/issues

Sets headless screen resolution on Windows.  It does this by creating a new user called `rdp_local` that has a
startup script to RDP into the specified user account at specified screen resolution (default is 1920x1080). A
firewall rule is created to open RDP port 3389. Finally, Windows auto-logon is configured to login as `rdp_local` 
on reboot.

Note that auto-logon requires a username and password and that the password is stored unencrypted under 
windows registry `HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon`.

Tested on Amazon Windows Server 2012 R2 AMI.

## Requirements

- Chef 11.6.0 or higher (includes a built-in registry_key resource)

## Platforms

- Windows

## Cookbook Dependencies

- windows_autologin

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
node.set['windows_screenresolution']['username'] = 'newuser'
node.set['windows_screenresolution']['password'] = 'N3wPassW0Rd'

include_recipe 'windows_screenresolution::default'
```

Set newuser's screen resolution to `1366x768`

```ruby
node.set['windows_screenresolution']['username'] = 'newuser'
node.set['windows_screenresolution']['password'] = 'N3wPassW0Rd'
node.set['windows_screenresolution']['width'] = 1366
node.set['windows_screenresolution']['height'] = 768

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
