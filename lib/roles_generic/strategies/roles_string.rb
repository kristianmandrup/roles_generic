require_all File.dirname(__FILE__) +'/roles_string'

module RoleModels::Generic
  module RolesString
    include RoleModels::Generic::Base
    include Implementation
  end
end
