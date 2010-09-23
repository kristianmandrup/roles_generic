module RoleStrategy::Generic
  module ManyRoles
    def self.default_role_attribute
      :many_roles
    end

    module Implementation      
      # assign roles
      def roles=(*_roles)          
        _roles = get_roles(_roles)
        return nil if !_roles || _roles.empty?        
        role_relations = role_class.find_roles(_roles)
        role_relations.each do |role_relation| 
          self.send("#{role_attribute}=", role_relation) if role_relation.kind_of?(role_class)
        end      
      end

      # query assigned roles
      def roles
        self.send(role_attribute)
      end

      def roles_list
        _roles = [roles].flatten.compact
        return [] if _roles.empty?
        _roles.map{|r| r.name }.compact
      end
    end

    extend Roles::Generic::User::Configuration
    configure :type => :role_class
    
    def self.included(base)
      base.extend Roles::Generic::Role::ClassMethods
    end      
  end
end
