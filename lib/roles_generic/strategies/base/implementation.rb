module RoleModels::Generic::Base
  module Implementation

    # check if a given role has been assigned 
    # if a list of roles: check if ALL of the given roles have been assigned 
    def has_roles?(*roles)
      (roles_list - roles.flatten).empty?      
    end

    # check if any (at least ONE) of the given roles have been assigned
    def has_role? *roles
      (roles_list & roles.flatten).not.empty?            
    end

    def valid_role? role
      available_roles.include? role.to_sym
    end

    def admin?
      is? :admin
    end
       
    def available_roles
      strategy_class.valid_roles      
    end
    
    alias_method :has?, :has_role?
    alias_method :is?, :has_roles?        
  end
end    
