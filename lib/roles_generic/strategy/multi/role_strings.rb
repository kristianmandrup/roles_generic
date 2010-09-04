require 'set'

module RoleStrategy::Generic
  module RoleStrings    
    def self.default_role_attribute
      :role_strings
    end    
    
    module Implementation
      # assign roles
      def roles=(*roles)
        new_roles = roles.flatten.map{|r| r.to_s if valid_role?(r)}.compact
        self.send("#{strategy_class.roles_attribute_name}=", ::Set.new(new_roles)) if new_roles && new_roles.not.empty?
      end

      # query assigned roles
      def roles
        self.send(strategy_class.roles_attribute_name).map{|r| r.to_sym}
      end
      
      def roles_list     
        [roles].flatten
      end      
    end

    extend Roles::Generic::User::Configuration
    configure            
  end
end
