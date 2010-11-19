module Roles::Generic::User
  module Implementation
    module Multi           
      def add_roles *roles
        new_roles = select_valid_roles(roles)        
        if !new_roles.empty?
          self.roles = self.roles + new_roles
        end
      end      
      
      # should remove the current single role (set = nil) 
      # only if it is contained in the list of roles to be removed
      def remove_roles *role_names
        role_names = role_names.flat_uniq
        set_empty_roles and return if roles_diff(role_names).empty?
        roles_to_remove = select_valid_roles(role_names)
        self.roles = roles_diff(role_names)
        true
      end

      def roles_list
        my_roles = [roles].flat_uniq
        my_roles.empty? ? [] : my_roles
      end      
    end
  end
end