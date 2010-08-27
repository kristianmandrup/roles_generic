module Roles
  module Base
    attr_accessor :orm_name

    def valid_roles
      strategy_class.valid_roles
    end

    def roles(*roles)
      strategy_class.valid_roles = Array[*roles].flatten.map { |r| r.to_sym }
    end
    
    def role_strategy strategy, options=nil
      include_strategy orm_name, strategy, options
    end  
         
    def include_strategy orm, strategy, options=nil 
      begin     
        constant = "Roles::#{orm_name.to_s.camelize}::#{strategy.to_s.camelize}".constantize

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
        raise "No Role strategy module for ORM #{orm} found for strategy #{strategy}"
      end
      constant.apply_options(options) if constant.respond_to? :apply_options
    end    
  end
end