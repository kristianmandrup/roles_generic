require 'roles_generic/role/class_methods'
require 'set'

module RoleModels::Generic
  module ManyRoles
    def self.default_role_attribute
      :many_roles
    end

    module Implementation
      # assign roles
      def roles=(*roles)  
        raise "Role class #{role_class} does not have a #find_role(role) method" if !role_class.respond_to? :find_role

        role_relations = role_class.find_roles(*roles)

        role_relations.each do |role_relation|        
          self.send("#{strategy_class.roles_attribute_name}=", role_relation) if role_relation.kind_of?(role_class)
        end      
      end

      # query assigned roles
      def roles
        self.send(strategy_class.roles_attribute_name)
      end

      def roles_list     
        [roles].flatten.map{|r| r.name }.compact
      end
    end

    extend RoleModels::Generic::Base::Configuration
    configure :type => :role_class
    
    def self.included(base)
      base.extend RoleModels::Generic::Base::RoleClass::ClassMethods
    end      
  end
end
