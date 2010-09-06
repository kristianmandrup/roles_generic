require 'sugar-high/file'
require 'sugar-high/array'

module Roles::Strategy
  class << self  
    NON_INLINE_STRATEGIES = [:one_role, :many_roles]
    
    def role_strategies cardinality
      pattern = File.dirname(__FILE__) + "/strategy/#{cardinality}/*.rb"
      Dir.glob(pattern).file_names(:rb).to_symbols
    end

    def has_strategy? cardinality, strategy
      role_strategies(cardinality).include?(strategy)
    end

    def inline_strategy? strategy
      !NON_INLINE_STRATEGIES.include? strategy.to_sym      
    end
  
    def cardinality strategy
      [:single, :multi].each do |cardinality|             
        return cardinality if has_strategy?(cardinality, strategy)
      end
      raise ArgumentError, "Strategy #{strategy}  is not registered as either a single or multi cardinality role strategy"
    end
  end
end           

def use_roles_strategy strategy
  cardinality = Roles::Strategy.cardinality(strategy)  
  require "roles_generic/strategy/#{cardinality}/#{strategy}"
  
  require 'roles_generic/role' if !Roles::Strategy.inline_strategy? strategy  
  require "roles_generic/strategy/#{cardinality}/#{strategy}"
end


