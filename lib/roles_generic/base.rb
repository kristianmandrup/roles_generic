module Roles
  module Base
    attr_accessor :orm_name
    attr_reader :role_strategy

    def valid_roles_are(*role_list)
      strategy_class.valid_roles = role_list.to_symbols
    end

    def valid_roles
      strategy_class.valid_roles
    end

    def roles(*roles)
      strategy_class.valid_roles = Array[*roles].flatten.map { |r| r.to_sym }
    end
    
    def set_role_strategy strategy_name, options=nil
      include_strategy orm_name, strategy_name, options
    end  

    class RoleStrategyId
      attr_accessor :name

      def initialize strategy_name
        @name = strategy_name.to_s.underscore.to_sym        
      end

      def type
        @type ||= case name
        when :one_role, :many_roles
          :complex
        else
          return :simple if name
        end
      end

      def multiplicity
        @multiplicity ||= case name
        when :many_roles, :role_strings, :roles_mask, :roles_string
          :multi
        when :one_role, :admin_flag, :role_string
          :single
        end      
      end
    end
         
    def include_strategy orm, strategy_name, options=nil 
      begin     
        module_name = "RoleStrategy::#{orm_name.to_s.camelize}::#{strategy_name.to_s.camelize}"
        constant = module_name.constantize
        @role_strategy = RoleStrategyId.new strategy_name
        strategy_class_method = %Q{
          def strategy_class
            #{constant} 
          end
        }
        
        class_eval do
          eval strategy_class_method
        end

        instance_eval do        
          eval strategy_class_method
          include constant
        end        
      rescue
        raise "No Role strategy module for ORM #{orm.to_s.camelize} for the strategy #{strategy_name}. Module #{module_name} has not been registered"
      end
      constant.apply_options(options) if constant.respond_to? :apply_options
    end    
  end
end