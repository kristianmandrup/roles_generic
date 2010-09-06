module RoleStrategy::Generic
  module ManyRoles
    def self.default_role_attribute
      :many_roles
    end

    module Implementation
      def role_attribute
        strategy_class.roles_attribute_name
      end       
      
      # assign roles
      def roles=(*roles)  
        raise "Role class #{role_class} does not have a #find_role(role) method" if !role_class.respond_to? :find_role

        role_relations = role_class.find_roles(*roles)
        role_relations.each do |role_relation| 
          self.send("#{role_attribute}=", role_relation) if role_relation.kind_of?(role_class)
        end      
      end

      # query assigned roles
      def roles
        self.send(role_attribute)
      end

      def roles_list     
        [roles].flatten.map{|r| r.name }.compact
      end
    end

    extend Roles::Generic::User::Configuration
    configure :type => :role_class
    
    def self.included(base)
      base.extend Roles::Generic::Role::ClassMethods
    end      
  end
end
