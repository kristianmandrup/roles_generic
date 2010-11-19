module RoleStrategy::Generic
  module OneRole
    def self.default_role_attribute
      :one_role
    end

    module Implementation      
      include Roles::Generic::User::Implementation::Single
      
      protected

      def new_role role
        role_class.find_role(role)        
      end  
      
      def new_roles *roles
        new_role roles.flatten.first
      end     
      
      def present_roles *roles
        roles.map{|role| extract_role role}
      end                 
      
      def set_empty_role
        self.send("#{role_attribute}=", nil)
      end
    end

    extend Roles::Generic::User::Configuration
    configure :num => :single, :type => :role_class
    
    def self.included(base)
      base.extend Roles::Generic::Role::ClassMethods
    end      
    
    include Roles::Generic::User::Implementation::Single
  end  
end
