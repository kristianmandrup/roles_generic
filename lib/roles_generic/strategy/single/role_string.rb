module RoleStrategy::Generic
  module RoleString    
    def self.default_role_attribute
      :role_string
    end
    
    module Implementation
      # assign roles
      def roles=(*roles)
        first_role = roles.flatten.first.to_s
        if valid_role? first_role
          self.send("#{role_attribute}=", first_role) 
        end
      end
      alias_method :role=, :roles=

      # query assigned roles
      def roles                   
        _role = self.send(role_attribute)
        return [] if !_role || _role.empty?

        [self.send(role_attribute).to_sym]
      end
      alias_method :roles_list, :roles
            
      # query assigned roles
      def add_roles *_roles
        new_roles = _roles.flatten.map{|r| r.to_s if valid_role?(r)}.compact
        if new_roles && new_roles.not.empty?
          new_role = new_roles.compact.uniq.first
          self.roles = new_role
        end
      end

      # query assigned roles
      def add_role _role
        raise ArgumentError, '#add_role takes a single role String or Symbol as the argument' if !_role || _role.kind_of?(Array)
        add_roles _role
      end      

      # query assigned roles
      def remove_roles *_roles
        # finds only valid roles      
        new_roles = self.roles_list - _roles.flatten
        new_role = new_roles.empty? ? nil : new_roles.first.to_s
        self.send("#{role_attribute}=", new_role) if new_role.nil? || valid_role?(new_role)
      end

      # query assigned roles
      def remove_role _role
        raise ArgumentError, "remove_role can only remove a single role" if role.kind_of? Array        
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

      def admin?
        roles_list.include? :admin
      end      
    end

    extend Roles::Generic::User::Configuration
    configure :num => :single
  end
end
