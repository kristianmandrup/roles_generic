require 'sugar-high/file'

module Roles::Strategy
  def self.role_strategies cardinality
    Dir.glob(File.dirname(__FILE) + "/#{cardinality}/*.rb").file_names
  end
  
  def self.cardinality strategy
    [:single, :multi].each do |cardinality|
      return role_strategies(cardinality).include?(strategy) 
    end
    raise ArgumentError, "Strategy #{strategy}  is not registered as either a single or multi cardinality role strategy"
  end
end