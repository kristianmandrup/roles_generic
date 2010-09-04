require 'sugar-high/file'
require 'sugar-high/array'

module Roles::Strategy
  def self.role_strategies cardinality
    pattern = File.dirname(__FILE__) + "/strategy/#{cardinality}/*.rb"
    Dir.glob(pattern).file_names(:rb).to_symbols
  end

  def self.has_strategy? cardinality, strategy
    role_strategies(cardinality).include?(strategy)
  end
  
  def self.cardinality strategy
    [:single, :multi].each do |cardinality|             
      return cardinality if has_strategy?(cardinality, strategy)
    end
    raise ArgumentError, "Strategy #{strategy}  is not registered as either a single or multi cardinality role strategy"
  end
end           

def use_roles_strategy strategy
  cardinality = Roles::Strategy.cardinality(strategy)
  require "roles_generic/strategy/#{cardinality}/#{strategy}"
end

