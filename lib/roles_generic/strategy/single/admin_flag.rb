module RoleStrategy::Generic
  module AdminFlag    
    def self.default_role_attribute
      :admin_flag
    end
                
    module Implementation            
      protected

      def new_role role
        role.admin?
      end
      
      def new_roles *roles
        new_role roles.flatten.first
      end      
      
      def get_role
        self.send(role_attribute) ? strategy_class.admin_role_key : strategy_class.default_role_key
      end 
      
      def present_roles *roles
        roles.map{|role| role ? :admin : :guest}
      end
      alias_method :present_role, :present_roles
      
      def set_empty_role
        self.send("#{role_attribute}=", false)
      end      
    end # Implementation

    extend Roles::Generic::User::Configuration
    configure :num => :single
    
    include Roles::Generic::User::Implementation::Single    
  end   
end

