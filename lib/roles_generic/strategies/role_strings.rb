require_all File.dirname(__FILE__) +'/role_strings'

module RoleModels::Generic
  module RoleStrings
    include RoleModels::Generic::Base
    include Implementation
  end
end
