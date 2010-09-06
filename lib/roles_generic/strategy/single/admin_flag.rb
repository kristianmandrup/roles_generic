module RoleStrategy::Generic
  module AdminFlag    
    def self.default_role_attribute
      :admin_flag
    end

    module Implementation
      def role_attribute
        strategy_class.roles_attribute_name
      end 
        
      # assign roles
      def roles=(*new_roles)                                 
        first_role = new_roles.flatten.first
        self.send("#{role_attribute}=", new_roles.flatten.first.admin?) if valid_role? first_role
      end

      # query assigned roles
      def roles
        role = self.send(role_attribute) ? strategy_class.admin_role_key : strategy_class.default_role_key
        [role]
      end
      alias_method :roles_list, :roles

    end # Implementation
    
    extend Roles::Generic::User::Configuration
    configure :num => :single
  end   
end

module AdminRoleCheck
  def admin?
    self.to_s.downcase.to_sym == :admin
  end
end  

class String
  include AdminRoleCheck
end

class Symbol
  include AdminRoleCheck
end
