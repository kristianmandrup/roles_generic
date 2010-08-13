module RoleModels::Generic::RolesString
  module ClassMethods      
    include RoleModels::Generic::Base::ClassMethods    

    def default_role_attribute
      :roles_string
    end

    def self.extended(base)
      base.instance_eval do
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
      RoleModels::Generic::RolesString
    end      
    
    # assign roles
    def roles=(*roles)
      roles_str = roles.flatten.map{|r| r.to_s if valid_role?(r)}.compact.uniq.join(',')
      self.send("#{strategy_class.roles_attribute_name}=", roles_str) if roles_str && roles_str.not.empty?
    end

    def admin?
      is? :admin
    end

    # query assigned roles
    def roles
      self.send(strategy_class.roles_attribute_name).split(',').uniq.map{|r| r.to_sym}
    end
    alias_method :role_symbols, :roles
    alias_method :roles_list, :roles    

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
      (roles_list & roles.flatten).not.empty?            
    end
    alias_method :has?, :has_role?
    # alias_method :have_role?, :has_role?

    def available_roles
      strategy_class.valid_roles      
    end
  end
end