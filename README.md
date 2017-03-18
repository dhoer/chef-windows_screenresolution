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

Set newuser's screen resolution to `1920x1080` (default)

``` ruby
windows_screenresolution 'newuser do
  password my_secret
  action :run
end
```

Set newuser's screen resolution to `1366x768`

```ruby
windows_screenresolution 'newuser do
  password my_secret
  width 1366
  height 768  
  action :run
end
```

### Attributes

- `username` - Username of account to remote login as (required).
- `password` - Password of account to remote login as (required).
- `width` -  Display width in pixels. Default: `1920`.
- `height` - Display height in pixels. Default: `1080`.
- `target` -   Identifies the computer or domain name that username and 
password account will be associated with for remote login. 
Default: `localhost`.
- `rdp_autologin` - Logon as RDP user automatically on reboot. Default:
`true`. Note that the password is stored unencrypted under windows 
registry `HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon`.
- `rdp_username` -  RDP username. Default: `rdp_local`.
- `rdp_password` - RDP password. Defaults to password of account to 
remote login as, if `nil`.
- `confidential` - Ensure that sensitive resource data is not logged by 
the chef-client. Default: `true`.

## ChefSpec Matchers

This cookbook includes custom [ChefSpec](https://github.com/sethvargo/chefspec) matchers you can use to test 
your own cookbooks.

Example Matcher Usage

```ruby
expect(chef_run).to run_windows_screenresolution('username').with(
  password: 'password'
)
```
      
Cookbook Matchers

- run_windows_screenresolution(resource_name)

## Getting Help

- Ask specific questions on [Stack Overflow](http://stackoverflow.com/questions/tagged/chef+windows+screen+resolution).
- Report bugs and discuss potential features in 
[Github issues](https://github.com/dhoer/chef-windows_screenresolution/issues).

## Contributing

Please refer to [CONTRIBUTING](https://github.com/dhoer/chef-windows_screenresolution/blob/master/CONTRIBUTING.md).

## License

MIT - see the accompanying [LICENSE](https://github.com/dhoer/chef-windows_screenresolution/blob/master/LICENSE.md) 
file for details.
