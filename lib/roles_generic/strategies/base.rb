require_all File.dirname(__FILE__) +'/base'

module RoleModels::Generic
  module Base
    INHERITABLE_CLASS_ATTRIBUTES = [:roles_attribute_name, :valid_roles]

    include Implementation

    def self.included(base) # :nodoc:
      base.extend ClassMethods
      base.class_eval do       
        class << self   
          attr_accessor(*::RoleModels::Generic::Base::INHERITABLE_CLASS_ATTRIBUTES)
          
          def apply_options options 
            roles_attribute default_role_attribute if options == :default
          end             
        end
      end
    end
  end
end



