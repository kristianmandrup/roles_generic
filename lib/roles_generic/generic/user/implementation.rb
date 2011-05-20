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
    def exchange_roles *role_names
      options = last_option role_names
      raise ArgumentError, "Must take an options hash as last argument with a :with option signifying which role(s) to replace with" if !options || !options.kind_of?(Hash)        
      remove_roles(role_names.to_symbols)        
      with_roles = options[:with]
      add_roles(with_roles)
    end
    
    def exchange_role role, options = {}
      raise ArgumentError, '#exchange_role takes a single role String or Symbol as the first argument' if !role || role.kind_of?(Array)
      raise ArgumentError, '#exchange_role takes a an options hash with a :with option as the last argument' if !options || !options[:with]
      if options[:with].kind_of?(Array) && self.class.role_strategy.multiplicity == :single                                                                                          
        raise ArgumentError, '#exchange_role should only take a single role to exchange with for a Role strategy with multiplicity of one' if options[:with].size > 1
      end 
      exchange_roles role, options
    end

    # is_in_group? :admin
    def is_in_group? group
      raise ArgumentError, 'Group id must be a String or Symbol' if !group.kind_of_label?
      group_roles = self.class.role_groups[group]
      # puts "group_roles: #{group_roles} for group: #{group}"
      # puts "roles_list: #{roles_list}"
      !(group_roles & roles_list).empty?
    end
    alias_method :is_member_of?, :is_in_group?

    # is_in_groups? :editor, :admin, 
    def is_in_groups? *groups
      groups = groups.flat_uniq
      groups.all? {|group| is_in_group? group}
    end

    def is_in_any_group? *groups
      groups = groups.flat_uniq
      groups.any? {|group| is_in_group? group}
    end

    # check if all of the roles listed have been assigned to that user 
    def has_roles?(*roles_names)
      compare_roles = extract_roles(roles_names.flat_uniq)
      (compare_roles - roles_list).empty?      
    end

    # check if any of the roles listed have been assigned to that user
    def has_any_role?(*roles_names)
      compare_roles = extract_roles(roles_names.flat_uniq)
      (roles_list & compare_roles).not.empty?      
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
      role_names = role_names.flat_uniq
      role_names = extract_roles(role_names)
      return nil if role_names.empty?
      set_roles(select_valid_roles role_names)
    end

    # query assigned roles
    def roles
      return [] if get_roles.nil?
      x = [get_roles].flatten.map do |role|
        role.respond_to?(:to_sym) ? role.to_sym : role
      end    
      x.first.kind_of?(Set) ? x.first.to_a : x
    end
           
    alias_method :has?, :has_role?
    alias_method :is?,  :has_roles? 

    def has_only_role? arg
      raise ArgumentError, "Must take only a single argument that is a role name" if arg.send(:size) > 1 && arg.kind_of?(Array)
      has_roles? [arg].flatten.first
    end

    alias_method :has_only?,  :has_only_role?
    alias_method :is_only?,   :has_only_role?
    
    protected

    def set_role role
      self.send("#{role_attribute}=", new_role(role))
    end
    alias_method :set_roles, :set_role
    
    def get_role
      r = self.send(role_attribute)
      respond_to?(:present_role) ? present_role(r) : r
    end

    def get_roles
      r = self.send(role_attribute)
      respond_to?(:present_roles) ? present_roles(r) : r
    end
    
    def set_roles *roles                      
      self.send("#{role_attribute}=", new_roles(roles))
    end

    def roles_diff *roles
      self.roles_list - extract_roles(roles.flat_uniq)
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
