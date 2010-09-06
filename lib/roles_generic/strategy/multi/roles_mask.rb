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

      def role_attribute
        strategy_class.roles_attribute_name
      end 

      # assign roles
      def roles=(*roles)
        self.send("#{role_attribute}=", (roles.flatten.map { |r| r.to_sym } & strategy_class.valid_roles).map { |r| calc_index(r) }.inject { |sum, bitvalue| sum + bitvalue })
      end
      alias_method :role=, :roles=

      # query assigned roles
      def roles
        strategy_class::Roles.new(self, strategy_class.valid_roles.reject { |r| ((self.send(role_attribute) || 0) & calc_index(r)).zero? })
      end

      def roles_list
        roles.to_a
      end        

      protected

      def calc_index(r)
        2**strategy_class.valid_roles.index(r)
      end
    end    
    
    extend Roles::Generic::User::Configuration
    configure            
  end
end
