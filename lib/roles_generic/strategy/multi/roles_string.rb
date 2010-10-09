module RoleStrategy::Generic
  module RolesString    
    def self.default_role_attribute
      :roles_string
    end

    module Implementation           
      # assign roles
      def roles=(*roles)
        roles_str = roles.flatten.map{|r| r.to_s if valid_role?(r)}.compact.uniq.join(',')
        self.send("#{role_attribute}=", roles_str) if roles_str && roles_str.not.empty?
      end 
      alias_method :role=, :roles=

      # query assigned roles
      def add_roles *_roles
        new_roles = _roles.flatten.map{|r| r.to_s if valid_role?(r)}.compact
        if new_roles && new_roles.not.empty?
          self.roles = (roles_list + new_roles).compact.uniq
        end
      end

      def add_role _role
        raise ArgumentError, '#add_role takes a single role String or Symbol as the argument' if !_role || _role.kind_of?(Array)
        add_roles _role
      end      

      # query assigned roles
      def remove_roles *_roles
        role_relations = _roles.flatten.compact.select{|r| valid_role? r}
        new_roles = roles - role_relations
        if new_roles.empty?
          self.send("#{role_attribute}=", "") 
        else
          self.roles = new_roles
        end
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
        self.send(role_attribute).split(',').uniq.map{|r| r.to_sym}
      end
      alias_method :roles_list, :roles
    end
    
    extend Roles::Generic::User::Configuration
    configure            
  end
end
