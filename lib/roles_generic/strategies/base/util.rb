module RoleModels::Generic::Base 
  module Configuration
    def configure(options={})
      numericality = options[:num]
      type = options[:type]
      
      class_eval do
        include RoleModels::Generic::Base
        include RoleModels::Generic::Base::SingleRole if numericality == :single
        include RoleModels::Generic::Base::RoleClass::InstanceMethods if type == :role_class
        include self::Implementation
        
        alias_method :role_symbols, :roles
      end
      extend RoleModels::Generic::Base::ClassMethods
      extend RoleModels::Generic::Base::DefaultRoleKeys
    end
  end
  
  module SingleRole
    def role
      roles.first
    end

    def role= new_role
      self.roles = new_role
    end
  end
  
  module DefaultRoleKeys
    def default_role_key
      valid_roles.last || :user
    end

    def admin_role_key
      valid_roles.first || :admin      
    end            
  end
end