# require_all File.dirname(__FILE__) +'/many_roles'

module RoleModels::Generic
  module ManyRoles
    module ClassMethods   
      def default_role_attribute
        :many_roles
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
        RoleModels::Generic::ManyRoles
      end

      # assign roles
      def roles=(*roles)  
        raise "Role class #{role_class} does not have a #find_role(role) method" if !role_class.respond_to? :find_role

        role_relations = role_class.find_roles(*roles)

        role_relations.each do |role_relation|        
          self.send("#{strategy_class.roles_attribute_name}=", role_relation) if role_relation.kind_of?(role_class)
        end      
      end

      # array of user roles
      def roles_list
        self.roles.to_a
      end  

      # query assigned roles
      def roles
        self.send(strategy_class.roles_attribute_name)
      end
      alias role_symbols roles

      # array of user roles
      def roles_list
        [roles].flatten.map{|r| r.name }.compact
      end
    end

    include RoleModels::Generic::Base
    include Implementation
    include RoleModels::Generic::Base::RoleClass::InstanceMethods

    def self.included(base)
      base.extend RoleModels::Generic::Base::RoleClass::ClassMethods      
    end            
  end
end
