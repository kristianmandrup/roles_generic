module Roles::Generic::Role
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
      begin
        @role_class_name = "#{const}".constantize
      rescue
        puts "Role class constant '#{const}' is not defined so it could not be set!"
      end
    end
  end    
end
