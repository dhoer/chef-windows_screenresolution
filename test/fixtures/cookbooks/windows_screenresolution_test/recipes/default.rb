user = 'display'
pass = '%2wNrk6z%Y-eJrv'

user user do
  password pass
end

node.override['windows_screenresolution']['username'] = user
node.override['windows_screenresolution']['password'] = pass

node['windows_screenresolution']['rdp_groups'].each do |group|
  group "associate user \"#{user}\" with \"#{group}\"" do
    group_name group
    members [user]
    append true
    action :modify
  end
end

include_recipe 'windows_screenresolution'
