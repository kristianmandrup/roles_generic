module RoleStrategy::Generic
  module OneRole
    def self.default_role_attribute
      :one_role
    end

    module Implementation
      # assign roles
      def roles=(*_roles)
        _roles = get_roles(_roles)

        return nil if !_roles || _roles.empty?

        first_role = _roles.flatten.first
        role_relation = role_class.find_role(first_role)
        if role_relation && role_relation.kind_of?(role_class)
          self.send("#{role_attribute}=", role_relation)
        end
      end
      
      # query assigned roles
      def roles
        [self.send(role_attribute)]
      end

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
        self.send("#{role_attribute}=", new_roles)
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
      
      def roles_list
        _roles = [roles].flatten.compact
        return [] if _roles.empty?
        _roles.map{|r| r.name.to_sym }.compact
      end      
    end

    extend Roles::Generic::User::Configuration
    configure :num => :single, :type => :role_class
    
    def self.included(base)
      base.extend Roles::Generic::Role::ClassMethods
    end      
  end  
end
