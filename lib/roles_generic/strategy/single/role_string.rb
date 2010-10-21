module RoleStrategy::Generic
  module RoleString    
    def self.default_role_attribute
      :role_string
    end
    
    module Implementation
      include Roles::Generic::User::Implementation::Single
      
      def new_role role
        role.to_s
      end

      def new_roles *roles
        new_role roles.flatten.first
      end
      
      def present_role role
        role.split(',').map(&:to_sym)
      end

      alias_method :present_roles, :present_role
    end

    extend Roles::Generic::User::Configuration
    configure :num => :single
  end
end
