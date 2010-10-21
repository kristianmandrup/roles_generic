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
      def remove_roles *roles
        roles = roles.flatten.compact
        return nil if roles_diff(roles).empty?
        roles_to_remove = select_valid_roles(roles)
        self.roles = self.roles - roles_to_remove
        true
      end

      def roles_list
        my_roles = [roles].flat_uniq
        my_roles.empty? ? [] : my_roles
      end      
    end
  end
end