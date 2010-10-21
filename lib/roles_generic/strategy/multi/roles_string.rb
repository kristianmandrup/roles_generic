module RoleStrategy::Generic
  module RolesString    
    def self.default_role_attribute
      :roles_string
    end

    module Implementation
      include Roles::Generic::User::Implementation::Multi
      
      protected

      def new_roles *roles
        roles.flatten.map{|r| r.to_s}.join(',')        
      end
      
      def present_roles
        split(',').uniq.map{|r| r.to_sym}        
      end      
    end
    
    extend Roles::Generic::User::Configuration
    configure            
  end
end
