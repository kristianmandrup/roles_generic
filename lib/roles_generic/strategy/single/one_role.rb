module RoleStrategy::Generic
  module OneRole
    def self.default_role_attribute
      :one_role
    end

    module Implementation 
      def role_attribute
        strategy_class.roles_attribute_name
      end 
      
      # assign roles
      def roles=(*roles)      
        raise "Role class #{role_class} does not have a #find_role(role) method" if !role_class.respond_to? :find_role

        first_role = roles.flatten.first
        role_relation = role_class.find_role(first_role)
        if role_relation && role_relation.kind_of?(role_class)
          self.send("#{role_attribute}=", role_relation)
        end        
      end
      
      # query assigned roles
      def roles
        [self.send(role_attribute).name.to_sym]
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
