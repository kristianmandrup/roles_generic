require_all File.dirname(__FILE__) +'/one_role'

module RoleModels::Generic
  module OneRole
    include RoleModels::Generic::Base
    include Implementation
    
    def self.included(base)
      base.instance_eval do
        def role_class_name
          @role_class_name          
        end

        def role_class class_constant
          const = class_constant.to_s.camelize
          @role_class_name = "#{const}".constantize
        end
      end
    end        
  end
end
