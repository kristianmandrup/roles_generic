require 'sugar-high/file'
require 'sugar-high/array'

module Roles::Strategy
  class << self  
    NON_INLINE_STRATEGIES = [:one_role, :many_roles]

    def role_dir
      File.dirname(__FILE__)
    end    

    def gem_name
      :roles_generic
    end    
    
    def role_strategies cardinality
      pattern = role_dir + "/strategy/#{cardinality}/*.rb"
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

  gem_name = Roles::Strategy.gem_name
  require "#{gem_name}/admin" if strategy =~ /admin/  
  require "#{gem_name}/role" if !Roles::Strategy.inline_strategy? strategy  
  require "#{gem_name}/strategy/#{cardinality}/#{strategy}"
end