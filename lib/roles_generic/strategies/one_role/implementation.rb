module RoleModels::Generic::OneRole
  module ClassMethods   
    def default_role_attribute
      :one_role
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
      RoleModels::Generic::OneRole
    end

    def role_class
      self.class.role_class_name
    end      

    # assign roles
    def roles=(*roles)      
      raise "Role class #{role_class} does not have a #find_role(role) method" if !role_class.respond_to? :find_role

      first_role = roles.flatten.first
      role_relation = role_class.find_role(first_role)
      
      if role_relation && role_relation.kind_of?(role_class)
        self.send("#{strategy_class.roles_attribute_name}=", role_relation)
      end        
    end

    # query assigned roles
    def roles
      role = self.send(strategy_class.roles_attribute_name).name.to_sym
      [role]
    end
    alias role_symbols roles

    def valid_role? role
      available_roles.include? role.to_sym
    end

    def admin?
      is? :admin
    end

    def role
      roles.first
    end

    # check if a given role has been assigned 
    # if a list of roles: check if ALL of the given roles have been assigned 
    def has_roles?(*roles)
      (self.roles.to_a - roles.flatten).empty?      
    end
    alias_method :is?, :has_roles?
    # alias_method :have_roles?, :has_roles?
    
    # check if any (at least ONE) of the given roles have been assigned
    def has_role? *roles
      (roles.flatten & self.roles).not.empty?            
    end
    alias_method :has?, :has_role?

    # array of user roles
    def roles_list
      roles
    end

    def available_roles
      role_class.valid_roles      
    end        
  end
end