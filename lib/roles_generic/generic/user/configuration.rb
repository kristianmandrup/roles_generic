module Roles::Generic::User 
  module Configuration
    def configure(options={})
      numericality = options[:num]
      type = options[:type]
      
      class_eval do
        include Roles::Generic::User
        include Roles::Generic::User::SingleRole if numericality == :single
        include Roles::Generic::Role::InstanceMethods if type == :role_class
        include self::Implementation
        
        alias_method :role_symbols, :roles
      end
      extend Roles::Generic::User::ClassMethods
      extend Roles::Generic::User::DefaultRoleKeys
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