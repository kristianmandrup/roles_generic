module RoleStrategy::Generic
  module ManyRoles
    def self.default_role_attribute
      :many_roles
    end

    module Implementation
      include Roles::Generic::User::Implementation::Multi
      
      def new_roles *roles
        role_class.find_role(*roles)        
      end            
    end

    extend Roles::Generic::User::Configuration
    configure :type => :role_class
    
    def self.included(base)
      base.extend Roles::Generic::Role::ClassMethods
    end      
  end
end
