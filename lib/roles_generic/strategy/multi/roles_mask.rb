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

      protected

      def calc_index(r)
        2**strategy_class.valid_roles.index(r)
      end

      def get_roles
        strategy_class::Roles.new(self, strategy_class.valid_roles.reject { |r| ((get_role || 0) & calc_index(r)).zero? })        
      end
      
      def new_roles *roles
        roles.flatten.map { |r| r.to_sym } & strategy_class.valid_roles).map { |r| calc_index(r) }.inject { |sum, bitvalue| sum + bitvalue }
      end      
    end    
    
    extend Roles::Generic::User::Configuration
    configure            
  end
end
