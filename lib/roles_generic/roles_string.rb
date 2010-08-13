require_all File.dirname(__FILE__) +'/roles_string'

module RoleModels::Generic
  module RolesString    
    def self.default_role_attribute
      :roles_string
    end

    module Implementation     
      # assign roles
      def roles=(*roles)
        roles_str = roles.flatten.map{|r| r.to_s if valid_role?(r)}.compact.uniq.join(',')
        self.send("#{strategy_class.roles_attribute_name}=", roles_str) if roles_str && roles_str.not.empty?
      end

      # query assigned roles
      def roles
        self.send(strategy_class.roles_attribute_name).split(',').uniq.map{|r| r.to_sym}
      end
      alias_method :roles_list, :roles
    end
    
    extend RoleModels::Generic::Base::Configuration
    configure            
  end
end
