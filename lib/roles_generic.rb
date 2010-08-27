require 'require_all'
require 'active_support/inflector'
require 'sugar-high/not'

require 'roles_generic/namespaces'
require 'roles_generic/base'
require 'roles_generic/generic'

def use_roles_strategy strategy
  cardinality = Roles::Strategy.cardinality(strategy)
  require "roles_generic/strategy/#{cardinality}/#{strategy}"
end