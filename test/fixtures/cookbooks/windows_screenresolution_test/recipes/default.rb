user = 'display'
pass = '%2wNrk6z%Y-eJrv'

user user do
  password pass
end

groups = ['Administrators', 'Remote Desktop Users']

groups.each do |group|
  group "associate user \"#{user}\" with \"#{group}\"" do
    group_name group
    members [user]
    append true
    action :modify
  end
end

windows_screenresolution user do
  password pass
  rdp_groups groups
  action :run
end
