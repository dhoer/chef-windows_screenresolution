name 'windows_screenresolution'
maintainer 'Dennis Hoer'
maintainer_email 'dennis.hoer@gmail.com'
license 'MIT'
description 'Sets headless screen resolution on Windows'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '1.0.1'

supports 'windows'

depends 'windows_autologin', '~> 1.0'
