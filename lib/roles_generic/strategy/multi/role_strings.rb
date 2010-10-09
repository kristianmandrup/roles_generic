module RoleStrategy::Generic
  module RoleStrings    
    def self.default_role_attribute
      :role_strings
    end    
    
    module Implementation      
      # assign roles
      def roles=(*roles)
        new_roles = roles.flatten.map{|r| r.to_s if valid_role?(r)}.compact
        self.send("#{role_attribute}=", ::Set.new(new_roles)) if new_roles && new_roles.not.empty?
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
        # finds only valid roles
        role_relations = _roles.flatten.compact.select{|r| valid_role? r}
        self.send("#{role_attribute}=", roles - role_relations)
        self.send(role_attribute).flatten!        
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
        self.send(role_attribute).map{|r| r.to_sym}
      end
      
      def roles_list     
        [roles].flatten
      end      
    end

    extend Roles::Generic::User::Configuration
    configure            
  end
end
