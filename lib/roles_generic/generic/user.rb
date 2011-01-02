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
            if options.kind_of?(Hash) && options[:attribute]
              roles_attribute options[:attribute] 
              return
            end
            roles_attribute default_role_attribute if default_options? options
          end
          
          private             
          
          def default_options? options
            return true if options == :default                           
            if options.kind_of? Hash
              return true # if options[:config] == :default || options == {} 
            end
            false
          end
        end
      end
    end
  end
end