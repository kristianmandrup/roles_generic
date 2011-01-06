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

        :roles_mask   => "attr_accessor :roles_mask",
        :role_string  => "attr_accessor :role_string",
        :role_strings => "attr_accessor :role_strings",
        :roles_string => "attr_accessor :roles_string",
        
        :embed_many_roles   => "attr_accessor :many_roles",
        :embed_one_role     => "attr_accessor :one_role"        
      }

      attr_accessor :role_groups
      def role_groups
        @role_groups ||= {}
      end
      
      def strategy name, options = {}
        strategy_name = name.to_sym
        raise ArgumentError, "Unknown role strategy #{strategy_name}" if !MAP.keys.include? strategy_name
        use_roles_strategy strategy_name
        
        if default_options?(options) && MAP[strategy_name]
          instance_eval MAP[strategy_name] 
        end       

        if strategies_with_role_class.include? strategy_name        
          if !options.kind_of? Symbol
            @role_class_name = get_role_class(options)
          else
            @role_class_name = default_role_class if strategies_with_role_class.include? strategy_name
          end
        end
        
        set_role_strategy name, options
      end    

      def add_role_groups(groups_hash)
        raise ArgumentError, "Role group must be passed a Hash where the key is the group name" if !groups_hash.kind_of? Hash
        groups_hash.each_pair do |key, list|
          add_role_group(key => list)
        end
      end

      # role_group :admin => :admin, :super_admin 
      def add_role_group(group_hash)
        raise ArgumentError, '#add_role_group must be passed a Hash where the key is the group name' if !group_hash.kind_of? Hash
        raise ArgumentError, '#add_role_group must be a Hash with a single key value pair' if group_hash.size > 1

        # first key/value pair?
        group = group_hash.keys.first # see sugar_high

        raise ArgumentError, "Role group identifier must be a String or Symbol " if !group.kind_of_label?      
        role_list = group_hash.values.first
        hash = {group.to_sym => [role_list].flat_uniq.to_symbols}

        role_groups.merge!(hash)
      end

      
      private

      def default_options? options = {}
        return true if options == :default                           
        if options.kind_of? Hash
          return true # if options[:config] == :default || options == {} 
        end
        false
      end

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
