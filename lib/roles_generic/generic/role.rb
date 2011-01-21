module Roles::Generic::Role
  module InstanceMethods        
    def role_class
      self.class.role_class_name
    end  
  end
  
  module ClassMethods 
    attr_accessor :class_constant
            
    def role_class_name
      const = class_constant.to_s.camelize
      begin
        @role_class_name ||= "#{const}".constantize
      rescue
        puts "Role class constant '#{const}' is not defined so it could not be set!"
      end
    end

    def role_class class_constant
      @class_constant = class_constant  
    end
  end    
end
