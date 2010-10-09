module RoleStrategy::Generic
  module RolesMask
    def self.default_role_attribute
      :roles_mask
    end

    module Implementation 
      class Roles < ::Set # :nodoc:
        attr_reader :model_instance

        def initialize(sender, *roles)
          super(*roles)
          @model_instance = sender
        end

        def <<(role)
          model_instance.roles = super.to_a
          self
        end
      end

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
        self.roles = roles - role_relations
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

      # assign roles
      def roles=(*roles)
        self.send("#{role_attribute}=", (roles.flatten.map { |r| r.to_sym } & strategy_class.valid_roles).map { |r| calc_index(r) }.inject { |sum, bitvalue| sum + bitvalue })
      end
      alias_method :role=, :roles=

      # query assigned roles
      def roles
        strategy_class::Roles.new(self, strategy_class.valid_roles.reject { |r| ((self.send(role_attribute) || 0) & calc_index(r)).zero? }).to_a
      end
      alias_method :roles_list, :roles

      protected

      def calc_index(r)
        2**strategy_class.valid_roles.index(r)
      end
    end    
    
    extend Roles::Generic::User::Configuration
    configure            
  end
end
