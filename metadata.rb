name 'windows_screenresolution'
maintainer 'Dennis Hoer'
maintainer_email 'dennis.hoer@gmail.com'
license 'MIT'
description 'Sets headless screen resolution on Windows'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
source_url 'https://github.com/dhoer/chef-windows_screenresolution' if respond_to?(:source_url)
issues_url 'https://github.com/dhoer/chef-windows_screenresolution/issues' if respond_to?(:issues_url)
version '3.0.0'

supports 'windows'

depends 'windows_home'
depends 'windows_autologin', '>= 3.0'
