module Roles::Generic::Role
  module InstanceMethods
    def role_class
      self.class.role_class_name
    end  

    def get_roles _roles
      raise "Role class #{role_class} does not have a #find_role(role) method" if !role_class.respond_to? :find_role
      _roles = _roles.flatten.compact    
      _roles = _roles.select{|role| role.kind_of?(role_class) || role.kind_of_label?}
      _roles.map! do |role| 
        case role
        when role_class
          role.name
        else
          role.to_s
        end
      end        
    end
  end

  module ClassMethods 
    def role_class_name
      @role_class_name          
    end

    def role_class class_constant
      const = class_constant.to_s.camelize
      @role_class_name = "#{const}".constantize
    end
  end    
end
