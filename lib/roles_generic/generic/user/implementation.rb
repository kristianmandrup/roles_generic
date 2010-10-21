module Roles::Generic::User
  module Implementation 
    include Roles::Generic::RoleUtil    
    
    def role_attribute
      strategy_class.roles_attribute_name
    end       

    # set a single role
    def role= role
      raise ArgumentError, '#add_role takes a single role String or Symbol as the argument' if !role || role.kind_of?(Array)
      self.roles = role
    end

    # add a single role
    def add_role role
      raise ArgumentError, '#add_role takes a single role String or Symbol as the argument' if !role || role.kind_of?(Array)
      add_roles role
    end

    # remove a single role
    def remove_role role
      raise ArgumentError, '#remove_role takes a single role String or Symbol as the argument' if !role || role.kind_of?(Array)
      remove_roles role
    end

    # should exchange the current role if in list with the first valid role in :with argument
    def exchange_roles *roles
      options = last_option roles
      raise ArgumentError, "Must take an options hash as last argument with a :with option signifying which role(s) to replace with" if !options || !options.kind_of?(Hash)        
      remove_roles(roles.to_symbols)        
      options[:with] = options[:with] if options[:with].kind_of? Array        
      add_roles options[:with]
    end
    
    def exchange_role role, options = {}
      raise ArgumentError, '#exchange_role takes a single role String or Symbol as the first argument' if !role || role.kind_of?(Array)
      raise ArgumentError, '#exchange_role takes a an options hash with a :with option as the last argument' if !options || !options[:with]
      exchange_roles role, options
    end

    # check if a given role has been assigned 
    # if a list of roles: check if ALL of the given roles have been assigned 
    def has_roles?(*roles_names)
      (roles_list - extract_roles(roles_names.flat_uniq)).empty?      
    end

    # check if any (at least ONE) of the given roles have been assigned
    def has_role? role_name
      raise ArgumentError, '#has_role? should take a single role String or Symbol as the argument' if !role_name || role_name.kind_of?(Array)
      has_roles? role_name
    end

    def valid_role? role
      strategy_class.valid_roles.include? role.to_sym
    end

    def valid_roles? *roles
      roles.each do |role|
        return false if !valid_role? role
      end
      true
    end

    def valid_roles
      strategy_class.valid_roles
    end

    def admin?
      is? :admin
    end

    # assign multiple roles
    def roles=(*role_names)
      role_names = extract_roles(role_names) 
      return nil if role_names.empty?
      set_roles(select_valid_roles role_names)
    end

    # query assigned roles
    def roles
      return [] if !get_roles
      get_roles.map do |role|
        role.respond_to?(:sym) ? role.to_sym : role
      end
    end
           
    alias_method :has?, :has_role?
    alias_method :is?,  :has_roles? 
    
    protected

    def set_role role
      self.send("#{role_attribute}=", new_role(role))
    end
    alias_method :set_roles, :set_role
    
    def get_role
      r = self.send(role_attribute)
      respond_to?(:present_role) ? r.present_role : r
    end

    def get_roles
      r = self.send(role_attribute)
      respond_to?(:present_roles) ? present_roles(r) : r
    end
    
    def set_roles *roles                      
      self.send("#{role_attribute}=", new_roles(roles))
    end

    def roles_diff *roles
      self.roles - roles.flat_uniq
    end
    
    def select_valid_roles *role_names
      role_names = role_names.flat_uniq.select{|role| valid_role? role }
      has_role_class? ? role_class.find_roles(role_names).to_a : role_names
    end           
        
    def has_role_class?
      self.respond_to?(:role_class)      
    end
  end
end    
