module RoleStrategy::Generic
  module ManyRoles
    def self.default_role_attribute
      :many_roles
    end

    module Implementation
      include Roles::Generic::User::Implementation::Multi
      
      def new_roles *role_names   
        role_class.find_roles(extract_roles role_names)        
      end            

      def present_roles roles_names
        roles_names.to_a.map{|role| role.name.to_s.to_sym}        
      end            
      
      def set_empty_roles
        self.send("#{role_attribute}=", [])
      end
    end

    extend Roles::Generic::User::Configuration
    configure :type => :role_class
    
    def self.included(base)
      base.extend Roles::Generic::Role::ClassMethods
    end      
  end
end
