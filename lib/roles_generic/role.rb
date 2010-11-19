module Roles::Base
  def valid_roles_are(*role_list)
    strategy_class.valid_roles = role_list.to_symbols
    if role_class_name
      role_list.each do |name| 
        role_class_name.new(name)
      end
    end
  end
end

class Role
  attr_accessor :name
  
  def self.find_role role_name    
    role_name = Roles::Generic::RoleUtil.extract_role(role_name)
    roles.to_a.select do |r| 
      r.name.to_sym == role_name.to_sym
    end.first
  end  

  def self.find_roles *role_names
    result = Set.new
    role_names.to_symbols.each do |role_name| 
      found_role = find_role(role_name)
      result << found_role if found_role
    end
    result
  end

  class << self
    attr_accessor :roles
    
    def all
      roles.to_a
    end
    
    def names
      roles.map(&:name)
    end
  end    
  
  def initialize name
    @name = name
    self.class.roles ||= Set.new
    self.class.roles << self
  end  
end
