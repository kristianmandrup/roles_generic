module RoleStrategy::Generic
  module RolesString    
    def self.default_role_attribute
      :roles_string
    end

    module Implementation           
      # assign roles
      def roles=(*roles)
        roles_str = roles.flatten.map{|r| r.to_s if valid_role?(r)}.compact.uniq.join(',')
        self.send("#{role_attribute}=", roles_str) if roles_str && roles_str.not.empty?
      end 
      alias_method :role=, :roles=

      # query assigned roles
      def roles
        self.send(role_attribute).split(',').uniq.map{|r| r.to_sym}
      end
      alias_method :roles_list, :roles
    end
    
    extend Roles::Generic::User::Configuration
    configure            
  end
end
