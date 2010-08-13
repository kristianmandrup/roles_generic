require_all File.dirname(__FILE__) +'/admin_flag'

module RoleModels::Generic
  module AdminFlag
    include RoleModels::Generic::Base
    include Implementation
    
    module ClassMethods
      include RoleModels::Generic::Base::ClassMethods
      def default_role_attribute
        :admin_flag
      end

      def self.extended(base)
        base.instance_eval do
          def default_role_key
            valid_roles.last || :user
          end

          def admin_role_key
            valid_roles.first || :admin      
          end            
        end
      end
    end  

    module Implementation  
      def self.included(base)   
        base.extend ClassMethods        
      end

      def strategy_class
        RoleModels::Generic::AdminFlag
      end

      # assign roles
      def roles=(*new_roles)                                 
        first_role = new_roles.flatten.first
        self.send("#{strategy_class.roles_attribute_name}=", new_roles.flatten.first.admin?) if valid_role? first_role
      end

      # query assigned roles
      def roles
        role = self.send(strategy_class.roles_attribute_name) ? strategy_class.admin_role_key : strategy_class.default_role_key
        [role]
      end
      alias_method :role_symbols, :roles
      alias_method :roles_list, :roles

      def admin?
        role == strategy_class.admin_role_key
      end

      def role
        roles.first
      end

      def role= new_role
        self.roles = new_role
      end

      def valid_role? role
        available_roles.include? role.to_sym
      end

      # check if a given role has been assigned 
      # if a list of roles: check if ALL of the given roles have been assigned 
      def has_roles?(*roles)
        (roles_list - roles.flatten).empty?      
      end
      alias_method :is?, :has_roles?
      # alias_method :have_roles?, :has_roles?

      # check if any (at least ONE) of the given roles have been assigned
      def has_role? *roles
        (roles.flatten & self.roles).not.empty?
      end
      alias_method :has?, :has_role?
      # alias_method :have_role?, :has_role?

      def available_roles
        strategy_class.valid_roles      
      end

    end      
  end   
end

