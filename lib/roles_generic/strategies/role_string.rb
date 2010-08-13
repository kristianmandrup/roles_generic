require_all File.dirname(__FILE__) +'/role_string'

module RoleModels::Generic
  module RoleString
    include RoleModels::Generic::Base
    include Implementation
  end
end
