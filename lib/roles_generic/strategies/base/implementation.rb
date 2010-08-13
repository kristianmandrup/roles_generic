module RoleModels::Generic::Base
  module Implementation
       
    def available_roles
      self.class.valid_roles      
    end
    
    # array of user roles
    def roles_list
      self.roles.to_a
    end
  end
end    
