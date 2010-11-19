module Roles::Generic::User
  module Implementation
    module Single
      # assigns first valid role from list of roles
      def add_roles *role_names
        new_roles = select_valid_roles(role_names)
        self.role = new_roles.first if !new_roles.empty?
      end

      # should remove the current single role (set = nil) 
      # only if it is contained in the list of roles to be removed
      def remove_roles *role_names
        roles = role_names.flat_uniq
        set_empty_role if roles_diff(roles).empty?
        true
      end 
      
      def roles_list
        raise 'the method #roles should be present' if !respond_to? :roles
        roles 
      end      
    end
  end
end