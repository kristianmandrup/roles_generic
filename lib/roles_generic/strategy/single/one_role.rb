module RoleStrategy::Generic
  module OneRole
    def self.default_role_attribute
      :one_role
    end

    module Implementation       
      # assign roles
      def roles=(*_roles)      
        _roles = get_roles(_roles)
        return nil if !_roles || _roles.empty?        

        first_role = _roles.flatten.first
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
