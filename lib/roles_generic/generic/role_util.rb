module Roles::Generic::RoleUtil
  # extract role symbols from roles
  # should handle symbols, strings, arrays and Role instances
  def extract_roles *roles
    roles.flatten.map{|role| extract_role role}.compact
  end

  def extract_role role
    role = case role
    when Array
      role.flat_uniq.first
    else
      role
    end

    if defined?(Role) && role.kind_of?(Role)
      raise 'Role instances should have a #name method that reflects the role name' if !role.respond_to? :name
      return role.name.to_s.to_sym
    end

    case role
    when String, Symbol
      role.to_sym
    else
      nil
    end
  end
  
  extend self
end