require_all File.dirname(__FILE__) +'/roles_mask'
# current RoleModel (with generic RolesMask strategy) needs to be available as RoleModels::Generic::RolesMask
module RoleModels::Generic
  module RolesMask
    include RoleModels::Generic::Base
    include Implementation    
  end
end
