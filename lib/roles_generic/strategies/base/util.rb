module RoleModels::Generic::Base 
  module Configuration
    def configure(base, option=nil) 
      base.class_eval do
        include RoleModels::Generic::Base
        include base::Implementation

        include RoleModels::Generic::Base::SingleRole if option == :single
        
        alias_method :role_symbols, :roles
        alias_method :roles_list, :roles    
      end
      base.extend RoleModels::Generic::Base::ClassMethods
      
      # base.extend base::ClassMethods
      base.extend RoleModels::Generic::Base::DefaultRoleKeys
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