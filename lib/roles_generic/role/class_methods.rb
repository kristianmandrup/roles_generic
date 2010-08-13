module RoleModels::Generic::Base
  module RoleClass
    module InstanceMethods
      def role_class
        self.class.role_class_name
      end      
    end
  
    module ClassMethods 
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