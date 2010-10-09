module RoleStrategy::Generic
  module ManyRoles
    def self.default_role_attribute
      :many_roles
    end

    module Implementation      
      # assign roles
      def roles=(*_roles)          
        _roles = get_roles(_roles)
        return nil if !_roles || _roles.empty?        
        role_relations = role_class.find_roles(_roles).select{|role| role.kind_of?(role_class) }
        self.send("#{role_attribute}=", role_relations)
      end
      alias_method :role=, :roles=

      # query assigned roles
      def add_roles *_roles
        new_roles = _roles.flatten.map{|r| r.to_s if valid_role?(r)}.compact
        if new_roles && new_roles.not.empty?          
          new_roles = new_roles.compact.uniq
          extra_roles = role_class.find_roles(new_roles).to_a
          self.roles = self.roles + extra_roles
        end
      end

      def add_role _role
        raise ArgumentError, '#add_role takes a single role String or Symbol as the argument' if !_role || _role.kind_of?(Array)
        add_roles _role
      end      

      # query assigned roles
      def remove_roles *_roles
        raise "Role class #{role_class} does not have a #find_role(role) method" if !role_class.respond_to? :find_role
        # finds only valid roles
        role_relations = role_class.find_roles(*_roles)
        new_roles = [roles].flatten - role_relations.to_a
        self.send("#{role_attribute}=", new_roles)
      end

      # query assigned roles
      def remove_role _role
        raise ArgumentError, "remove_role can only remove a single role" if _role.kind_of? Array        
        remove_roles _role
      end      

      # query assigned roles
      def exchange_roles *_roles
        options = last_option _roles
        raise ArgumentError, "Must take an options hash as last argument with a :with option signifying which role(s) to replace with" if !options || !options.kind_of?(Hash)        
        remove_roles(_roles.to_symbols)
        options[:with] = options[:with].flatten if options[:with].kind_of? Array        
        add_roles options[:with]
      end
      alias_method :exchange_role, :exchange_roles      

      # query assigned roles
      def roles
        self.send(role_attribute)
      end

      def roles_list
        _roles = [roles].flatten.compact
        return [] if _roles.empty?
        _roles.map{|r| r.name.to_sym }.compact
      end
    end

    extend Roles::Generic::User::Configuration
    configure :type => :role_class
    
    def self.included(base)
      base.extend Roles::Generic::Role::ClassMethods
    end      
  end
end
