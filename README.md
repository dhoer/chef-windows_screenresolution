# Windows Screen Resolution Cookbook

[![Cookbook Version](http://img.shields.io/cookbook/v/windows_screenresolution.svg?style=flat-square)][cookbook]
[![Build Status](http://img.shields.io/travis/dhoer/chef-windows_screenresolution.svg?style=flat-square)][travis]
[![GitHub Issues](http://img.shields.io/github/issues/dhoer/chef-windows_screenresolution.svg?style=flat-square)][github]

[cookbook]: https://supermarket.chef.io/cookbooks/windows_screenresolution
[travis]: https://travis-ci.org/dhoer/chef-windows_screenresolution
[github]: https://github.com/dhoer/chef-windows_screenresolution/issues

Sets headless screen resolution on Windows.  It also contains a `screenresolution` library method that returns the 
current screen resolution.

Tested on Amazon Windows Server 2012 R2 AMI.

## Requirements

- Chef 11.6.0 or higher
- Windows Server 2008 R2 or higher due to its API usage

## Platforms

- Windows

## Usage

Include `windows_screenresolution` as a dependency to use `screenresolution` method.

Method `screenresolution` returns display resolution (e.g. '1600x1200').

#### Example

```ruby
display = screenresolution
```

### windows_screenresolution

Creates a new Remote Desktop Protocol (RDP) user that logs into a specified user account at the display resolution
required.  Note that auto-logon requires a username and password for auto-logon and that the password is stored
unencrypted under windows registry `HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon`.

#### Attributes

- `username` - Username of account to remote login as (required).
- `password` - Password of account to remote login as (required).
- `width` -  Display width in pixels. Defaults to `1600`.
- `height` - Display height in pixels. Defaults to `1200`.
- `target` -   Identifies the computer or domain name that username and password account will be associated with
for remote login. Defaults to `localhost`.
- `rdp_autologon` - Logon as RDP user automatically on reboot. Defaults to `true`. Note that the password is stored
unencrypted under windows registry `HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon`.
- `rdp_username` -  RDP username. Defaults to `rdp_local`.
- `rdp_password` - RDP password. Defaults to password of account to remote login as, if `nil`.
- `rdp_domain` -  RDP domain. Defaults to `nil`.

#### Example

```ruby
windows_screenresolution 'newuser' do
  password 'N3wPassW0Rd'
  width 1440
  height 900
end
```

## ChefSpec Matchers

The Chrome cookbook includes a custom [ChefSpec](https://github.com/sethvargo/chefspec) matcher you can use to test your
own cookbooks.

Example Matcher Usage

```ruby
expect(chef_run).to run_windows_screenresolution('username').with(
  password: 'N3wPassW0Rd'
  width: 1440
  height: 900
)
```

Windows Display Cookbook Matcher

- run_windows_screenresolution(username)

## Getting Help

- Ask specific questions on [Stack Overflow](http://stackoverflow.com/questions/tagged/chef-windows_screenresolution).
- Report bugs and discuss potential features in [Github issues](https://github.com/dhoer/chef-windows_screenresolution/issues).

## Contributing

Please refer to [CONTRIBUTING](https://github.com/dhoer/chef-windows_screenresolution/blob/master/CONTRIBUTING.md).

## License

MIT - see the accompanying [LICENSE](https://github.com/dhoer/chef-windows_screenresolution/blob/master/LICENSE.md) file for
details.
