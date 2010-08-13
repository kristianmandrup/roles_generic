module RoleModels::Generic::ManyRoles
  module ClassMethods   
    def default_role_attribute
      :many_roles
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

    def role_class
      self.class.role_class_name
    end      

    def strategy_class
      RoleModels::Generic::ManyRoles
    end

    # assign roles
    def roles=(*roles)  
      raise "Role class #{role_class} does not have a #find_role(role) method" if !role_class.respond_to? :find_role

      role_relations = role_class.find_roles(*roles)
      
      role_relations.each do |role_relation|        
        self.send("#{strategy_class.roles_attribute_name}=", role_relation) if role_relation.kind_of?(role_class)
      end      
    end

    # query assigned roles
    def roles
      self.send(strategy_class.roles_attribute_name)
    end
    alias role_symbols roles

    def admin?
      is? :admin
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
      (roles_list & roles.flatten).not.empty?            
    end
    alias_method :has?, :has_role?

    # array of user roles
    def roles_list
      [roles].flatten.map{|r| r.name }.compact
    end

    def available_roles
      role_class.valid_roles      
    end    
  end
end