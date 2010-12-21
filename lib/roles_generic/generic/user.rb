require_all File.dirname(__FILE__) +'/user'

module Roles::Generic
  module User
    INHERITABLE_CLASS_ATTRIBUTES = [:roles_attribute_name, :valid_roles]

    include Implementation

    def self.included(base) # :nodoc:
      base.extend ClassMethods
      base.class_eval do       
        class << self   
          attr_accessor(*::Roles::Generic::User::INHERITABLE_CLASS_ATTRIBUTES)
          
          def apply_options options = {}
            roles_attribute default_role_attribute if options == :default || options[:config] == :default                        
          end             
        end
      end
    end
  end
end