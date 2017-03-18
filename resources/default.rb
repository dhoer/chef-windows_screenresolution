actions :run
default_action :run

attribute :username, kind_of: String, name_attribute: true
attribute :password, kind_of: String, required: true
attribute :width, kind_of: Integer, default: 1920
attribute :height, kind_of: Integer, default: 1080

attribute :target, kind_of: String, default: 'localhost'
attribute :rdp_autologin, kind_of: [TrueClass, FalseClass], default: true
attribute :rdp_groups, kind_of: Array, default: ['Administrators', 'Remote Desktop Users']
attribute :rdp_username, kind_of: String, default: 'rdp_local'
attribute :rdp_password, kind_of: [String, NilClass]

attribute :confidential, kind_of: [TrueClass, FalseClass], default: true
