require_all File.dirname(__FILE__) +'/one_role'

module RoleModels::Generic
  module OneRole
    module ClassMethods   
      def default_role_attribute
        :one_role
      end

      def self.extended(base)
        base.extend RoleModels::Generic::Base::DefaultRoleKeys
      end
    end

    module Implementation
      def self.included(base)
        base.extend ClassMethods
      end    

      def strategy_class
        RoleModels::Generic::OneRole
      end

      # assign roles
      def roles=(*roles)      
        raise "Role class #{role_class} does not have a #find_role(role) method" if !role_class.respond_to? :find_role

        first_role = roles.flatten.first
        role_relation = role_class.find_role(first_role)
        if role_relation && role_relation.kind_of?(role_class)
          self.send("#{strategy_class.roles_attribute_name}=", role_relation)
        end        
      end

      # array of user roles
      def roles_list
        self.roles.to_a
      end

      # query assigned roles
      def roles
        role = self.send(strategy_class.roles_attribute_name).name.to_sym
        [role]
      end
    end

    include RoleModels::Generic::Base
    include Implementation 
    include RoleModels::Generic::Base::SingleRole
    include RoleModels::Generic::Base::RoleClass::InstanceMethods
    
    def self.included(base)
      base.extend RoleModels::Generic::Base::RoleClass::ClassMethods
    end        
  end  
end
