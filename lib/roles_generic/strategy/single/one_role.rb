require 'set'

module RoleStrategy::Generic
  module OneRole
    def self.default_role_attribute
      :one_role
    end

    module Implementation
      # assign roles
      def roles=(*roles)      
        raise "Role class #{role_class} does not have a #find_role(role) method" if !role_class.respond_to? :find_role

        first_role = roles.flatten.first
        role_relation = role_class.find_role(first_role)
        if role_relation && role_relation.kind_of?(role_class)
          self.send("#{strategy_class.roles_attribute_name}=", role_relation)
        end        
      end
      
      # query assigned roles
      def roles
        role = self.send(strategy_class.roles_attribute_name).name.to_sym
        [role]
      end
      
      def roles_list
        self.roles.to_a
      end      
    end

    extend Roles::Generic::User::Configuration
    configure :num => :single, :type => :role_class
    
    def self.included(base)
      base.extend Roles::Generic::Role::ClassMethods
    end      
  end  
end
