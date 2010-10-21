module RoleStrategy::Generic
  module RoleStrings    
    def self.default_role_attribute
      :role_strings
    end    
    
    module Implementation      
      include Roles::Generic::User::Implementation::Multi
      
      def new_roles *roles
        ::Set.new select_valid_roles(roles)
      end      

      def select_valid_roles *roles
        roles.flat_uniq.select{|role| valid_role? role }.map(&:to_sym)
      end                 
      
      def set_empty_roles
        self.send("#{role_attribute}=", [])
      end      
    end

    extend Roles::Generic::User::Configuration
    configure            
  end
end
