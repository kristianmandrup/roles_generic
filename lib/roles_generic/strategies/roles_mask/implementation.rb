require 'set'

module RoleModels::Generic::RolesMask
  module ClassMethods      
    include RoleModels::Generic::Base::ClassMethods    

    def default_role_attribute
      :roles_mask
    end

    def self.extended(base)
      base.instance_eval do
        def admin_role_key
          valid_roles.first || :admin      
        end            
      end
    end
  end    

  module Implementation 
    class Roles < ::Set # :nodoc:
      attr_reader :model_instance

      def initialize(sender, *roles)
        super(*roles)
        @model_instance = sender
      end

      def <<(role)
        model_instance.roles = super.to_a
        self
      end
    end
    
    
    def self.included(base)
      # import RoleModel instance methods into base
      # base.class_eval do
      #   include RoleModel
      # end      
      base.extend ClassMethods
    end

    def strategy_class
      RoleModels::Generic::RolesMask
    end      
    
    # assign roles
    def roles=(*roles)
      self.send("#{role_att_name}=", (roles.flatten.map { |r| r.to_sym } & valid_roles).map { |r| calc_index(r) }.inject { |sum, bitvalue| sum + bitvalue })
    end

    # query assigned roles
    def roles
      Roles.new(self, valid_roles.reject { |r| ((role_value || 0) & calc_index(r)).zero? })
    end
    alias_method :role_symbols, :roles

    # check if a given role has been assigned 
    # if a list of roles: check if ALL of the given roles have been assigned 
    # uses set difference -> if difference is empty
    def has_roles?(*roles)
      (roles_list - roles.flatten).empty?      
    end
    alias_method :is?, :has_roles?
    # alias_method :have_roles?, :has_roles?
    
    # check if any (at least ONE) of the given roles have been assigned
    # uses set union -> if union is non empty
    def has_role? *roles
      !(roles_list & roles.flatten).empty?            
    end
    alias_method :has?, :has_role?
    # alias_method :have_role?, :has_role?

    def admin?
      is? :admin
    end

    # array of user roles
    def roles_list
      self.roles.to_a
    end        

    def valid_roles
      strategy_class.valid_roles      
    end            
    
    protected
    
    def calc_index(r)
      2**strategy_class.valid_roles.index(r)
    end

    def role_att_name
      strategy_class.roles_attribute_name      
    end

    def role_value
      self.send(role_att_name)
    end          
  end
end