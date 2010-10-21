module Roles::Generic::RoleUtil
  # extract role symbols from roles
  # should handle symbols, strings, arrays and Role instances
  def extract_roles *roles
    roles.flatten.map{|role| extract_role role}.compact
  end

  def extract_role role
    case role
    when Role
      raise 'Role instances should have a #name method that reflects the role name' if !role.respond_to? :name
      role.name.to_s.to_sym
    when String, Symbol
      role.to_sym
    else
      nil
    end 
  end
  
  extend self
end