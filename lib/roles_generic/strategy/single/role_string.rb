require 'set'

module RoleStrategy::Generic
  module RoleString    
    def self.default_role_attribute
      :role_string
    end
    
    module Implementation             
      # assign roles
      def roles=(*roles)
        first_role = roles.flatten.first.to_s                                    
        if valid_role? first_role
          self.send("#{strategy_class.roles_attribute_name}=", first_role) 
        end
      end

      # query assigned roles
      def roles
        role = self.send(strategy_class.roles_attribute_name)
        [role.to_sym]
      end
      alias_method :roles_list, :roles
    end

    extend Roles::Generic::User::Configuration
    configure :num => :single
  end
end
