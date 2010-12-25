require_all File.dirname(__FILE__) + '/generic'

module Roles
  module Generic  
    def self.included(base) 
      base.extend Roles::Base
      base.extend ClassMethods
      base.orm_name = :generic
    end

    module ClassMethods
      
      MAP = {
        :admin_flag   => "attr_accessor :admin_flag",

        :many_roles   => "attr_accessor :many_roles",
        :one_role     => "attr_accessor :one_role",

        :embed_many_roles   => "attr_accessor :many_roles",
        :embed_one_role     => "attr_accessor :one_role",

        :roles_mask   => "attr_accessor :roles_mask",
        :role_string  => "attr_accessor :role_string",
        :role_strings => "attr_accessor :role_strings",
        :roles_string => "attr_accessor :roles_string"
      }
      
      def strategy name, options = {}
        strategy_name = name.to_sym
        raise ArgumentError, "Unknown role strategy #{strategy_name}" if !MAP.keys.include? strategy_name
        use_roles_strategy strategy_name
        
        if (options == :default || options[:config] == :default) && MAP[name]
          instance_eval MAP[strategy_name] 
        end       
        
        if !options.kind_of? Symbol
          @role_class_name = get_role_class(options)
        else
          @role_class_name = default_role_class if strategies_with_role_class.include? strategy_name
        end

        set_role_strategy name, options
      end    
      
      private

      def default_role_class
        return ::Role if defined? ::Role
        raise Error, "Default Role class not defined"
      end

      def strategies_with_role_class
        [:one_role, :embed_one_role, :many_roles,:embed_many_roles]
      end 
      
      def get_role_class options
        options[:role_class] ? options[:role_class].to_s.camelize.constantize : default_role_class
      end
    end
  end
end
