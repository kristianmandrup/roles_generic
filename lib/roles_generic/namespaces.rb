require 'sugar-high/module'

module Roles
  modules :generic do
    nested_modules :user, :role
  end
  modules :base, :strategy
end   

module RoleStrategy
  module Generic
  end
end
