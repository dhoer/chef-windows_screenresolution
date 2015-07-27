include Chef::Mixin::ShellOut

def screenresolution
  if platform?('windows')
    if windows_version.windows_server_2012_r2?
      shell_out('powershell.exe Get-DisplayResolution').stdout
    else
      log('Method screenresolution is only for Windows Server 2012 R2!') { level :warn }
    end
  else
    log('Method screenresolution is only available for Windows platform!') { level :warn }
  end
end

private

# https://docs.chef.io/dsl_recipe.html#helpers
def windows_version
  require 'chef/win32/version'
  Chef::ReservedNames::Win32::Version.new
end
